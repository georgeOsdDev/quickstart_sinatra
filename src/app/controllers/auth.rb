get '/auth' do
  "auth"
end

get '/auth/logout' do
  request.env["warden"].logout
  session.clear
  json(status: 0)
end
