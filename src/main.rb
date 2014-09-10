require 'rubygems'
require 'bundler'
Bundler.require
require 'sinatra/reloader' if development?

# Application Main
class MyApp < Sinatra::Application
  Dir['./app/models/*.rb'].each { |file| require file }
  Dir['./app/helpers/*.rb'].each { |file| require file }
  Dir['./app/controllers/**/*.rb'].each { |file| require file }

  # Common before filter & handlers
  before do
    env['rack.logger'] = Logger.new("./logs/#{settings.environment}-app.log", 'daily', 10)
    env['rack.errors'] = Logger.new("./logs/#{settings.environment}-error.log", 'daily', 10)
    logger.error 'Before filter'
  end

  before '/api/*' do
    request.env["warden"].authenticate!
  end

  not_found do
    logger.debug 'Not Found'
    json(http_status: '404',)
  end

  error do
    logger.error 'System Error'
    json(http_status: '500', message: env['sinatra.error'].message)
  end

  after do
    logger.debug 'After filter'
  end
end
