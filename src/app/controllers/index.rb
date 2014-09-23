#encoding: utf-8
get '/' do
  logger.debug "debug"
  logger.error "error"
  logger.info "info"
  "welcome"
end

get '/test/exception' do
  raise "I am exception"
end
