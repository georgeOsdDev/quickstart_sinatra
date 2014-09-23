#encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.require
require 'sinatra/reloader' if development?

# Application Main
class MyApp < Sinatra::Application
  Dir['./app/models/**/*.rb'].each { |file| require file }
  Dir['./app/helpers/**/*.rb'].each { |file| require file }
  Dir['./app/controllers/**/*.rb'].each { |file| require file }

  # Use warden as authorization manager
  # See also https://github.com/nmattisson/sinatra-warden-api/blob/master/app.rb
  use Warden::Manager do |config|
    config.scope_defaults :default,
    strategies: [:valid_token],
    action: '/auth/unauthenticated'
    config.failure_app = Sinatra::Application
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:valid_token) do
    def valid?
      request.env["HTTP_X_APPUID"].is_a?(String) && request.env["HTTP_X_APPTOKEN"].is_a?(String)
    end

    def authenticate!
      user = User.find(request.env["HTTP_X_APPUID"]) or
              raise ActiveRecord::RecordNotFound
      if user.token == request.env["HTTP_X_APPTOKEN"]
        success!(user)
      else
        fail!("invalid token")
      end
    end
  end

  # Common before filter & handlers
  before do
    logger.debug '-----Request Start-----'
    logger.debug request.inspect
    logger.debug '-----Request End-----'
    content_type 'application/json'
  end

  before '/api/*' do
    logger.debug '-----Before API-----'
    request.env["warden"].authenticate!
  end

  not_found do
    logger.debug 'Not Found'
    logger.debug env['sinatra.error'].inspect
    status 404
    MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_404, message: "")
  end

  error Sinatra::Param::InvalidParameterError do
    logger.debug 'Invalid Request'
    logger.debug env['sinatra.error'].inspect
    status 400
    MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_INVALID_REQUEST_PARAM, message: "#{env['sinatra.error'].param} is invalid")
  end

  error ActiveRecord::RecordNotFound do
    logger.debug env['sinatra.error'].inspect
    status 500
    MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_500, message: env['sinatra.error'].message)
  end

  error do
    logger.error 'System Error'
    logger.debug env['sinatra.error'].inspect
    status 500
    MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_500, message: env['sinatra.error'].message)
  end

  after do
    # Session is not used
    session["warden.user.default.key"] = nil
    logger.debug '-----Response Start-----'
    logger.debug response.inspect
    logger.debug '-----Response End-----'
  end
end
