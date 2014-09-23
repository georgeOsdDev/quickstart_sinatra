#encoding: utf-8

post '/auth/login' do

  result = {
    status:      STATUS_SUCCESS,
    data:{}
  }
  MultiJson.encode result
end

post '/auth/unauthenticated' do
  status 403
  MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_403, message: "Not authenticated")
end

post '/auth/logout' do
  request.env["warden"].logout
  session.clear
  MultiJson.encode(status: 0, data:[])
end
