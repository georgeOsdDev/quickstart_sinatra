require './constant'
require './main'

Encoding.default_external = "utf-8" if defined?(Encoding) && Encoding.respond_to?("default_external")
ENV["TZ"] = "Asia/Tokyo"
Time.zone = "Tokyo"
ActiveRecord::Base.default_timezone = :local

PROJECT_ROOT = Sinatra::Application.root

# Configuration to use when running within Sinatra
configure do

  set :run, false
  set :app_file, __FILE__

  # enable the POST _method hack
  set :method_override, true

  set :raise_sinatra_param_exceptions, true

  # Access Log
  accessLog = File.new("#{PROJECT_ROOT}/logs/#{settings.environment}-access.log", 'a+')
  accessLog.sync = true
  use Rack::CommonLogger, accessLog

  # Application Log
  applog = File.new("#{PROJECT_ROOT}/logs/#{settings.environment}-application.log", 'a+')
  $stdout.reopen(applog)
  $stderr.reopen(applog)
  $stdout.sync=true
  $stderr.sync=true

  # Load config from file
  register Sinatra::ConfigFile
  config_file './config/secret.yml'

  # Basic auth before static server

  use Rack::Auth::Basic, settings.basic_auth_realm do |username, password|
    username == settings.basic_auth_name and password == settings.basic_auth_pass
  end
  use Rack::Static, :urls => ["/images"], :root => "static"


  # Session is used with warden, See also main.rb
  use Rack::Session::Cookie, secret: settings.session_key
end

configure :development do
  register Sinatra::Reloader
  set :dump_errors, false
  set :show_exceptions, false
  set :logging, Logger::DEBUG
end

configure :production do
  set :dump_errors, false
  set :show_exceptions, false
  set :logging, Logger::INFO
end

run MyApp.new
