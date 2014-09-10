get '/' do
  if session[:uid].nil?
      redirect '/auth'
  else
    "welcome #session[:uid]"
  end
end

get '/test/exception' do
  raise "I am exception"
end
