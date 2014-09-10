require './main'
require './middlewares/appLogger'
# Configuration to use when running within Sinatra
project_path          = Sinatra::Application.root

# # HTTP paths
# http_path             = '/'
# http_stylesheets_path = '/stylesheets'
# http_images_path      = '/images'
# http_javascripts_path = '/javascripts'
#
# # File system locations
# css_dir               = File.join 'public', 'stylesheets'
# images_dir            = File.join 'public', 'images'
# javascripts_dir       = File.join 'public', 'javascripts'

configure do
  set :run, false
  set :app_file, __FILE__

  set :dump_errors, true
  set :show_exceptions, false

  set :method_override, true

  set :static, false
  set :public_folder, proc { File.join(root, 'public') }
  set :views, proc { File.join(root, 'app.view') }

  accessLog = File.new("#{project_path}/logs/#{settings.environment}-access.log", 'a+')
  accessLog.sync = true
  use Rack::CommonLogger, accessLog

  # Load config from file
  register Sinatra::ConfigFile
  config_file './config/secret.yml'

  use Rack::Session::Cookie, secret: settings.session_key

  ENV['fb_app_id']     = settings.fb_app_id     if defined? settings.fb_app_id
  ENV['fb_app_secret'] = settings.fb_app_secret if defined? settings.fb_app_secret

  use OmniAuth::Builder do
    provider :facebook, ENV['fb_app_id'], ENV['fb_app_secret'], scope: 'email, user_friends'
  end

end

configure :development do
  register Sinatra::Reloader
  set :logging, Logger::DEBUG
end

configure :production do
  set :logging, Logger::INFO
end

# Use warden as authorization manager
# See also https://github.com/nmattisson/sinatra-warden-api/blob/master/app.rb
use Warden::Manager do |config|
    config.scope_defaults :default,
    # Set your authorization strategy
    strategies: [:access_token],
    # Route to redirect to when warden.authenticate! returns a false answer.
    action: '/auth/unauthenticated'
    config.failure_app = self
end

Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
end

# Implement your Warden stratagey to validate and authorize the access_token.
Warden::Strategies.add(:access_token) do
    def valid?
        # Validate that the access token is properly formatted.
        # Currently only checks that it's actually a string.
        request.env["HTTP_ACCESS_TOKEN"].is_a?(String)
    end

    def authenticate!
        # Authorize request if HTTP_ACCESS_TOKEN matches 'youhavenoprivacyandnosecrets'
        # Your actual access token should be generated using one of the several great libraries
        # for this purpose and stored in a database, this is just to show how Warden should be
        # set up.
        access_granted = (request.env["HTTP_ACCESS_TOKEN"] == 'youhavenoprivacyandnosecrets')
        !access_granted ? fail!("Could not log in") : success!(access_granted)
    end
end

run MyApp.new
