#encoding: utf-8


# リクエストされた内容をレスポンスに含めて返却します。GETテスト用
#
# == Request:
# data::
#   レスポンスに含めたいデータ
#
# == Response JSON:
# status:: 常に0
#
# data:: リクエストで受け取ったdataパラメータ
#
get "/api/dummy/success" do
  result = {
    status: STATUS_SUCCESS,
    data:   params["data"]
  }
  MultiJson.encode result
end


# リクエストされた内容をレスポンスに含めて返却します。POSTテスト用
#
# == Request:
# data::
#   レスポンスに含めたいデータ
#
# == Response JSON:
# status:: 常に0
#
# data:: リクエストで受け取ったdataパラメータ
#
post "/api/dummy/success" do
  result = {
    status: STATUS_SUCCESS,
    data:   params["data"]
  }
  MultiJson.encode result
end

# リクエストされた内容をレスポンスに含めて返却します。GETエラーテスト用
#
# == Request:
# error_cd:: レスポンスに含めたいerror_cd
#
# message:: レスポンスに含めたいmessage
#
# == Response JSON:
# status:: 常に1
#
# error_cd:: リクエストで受け取ったerror_cdパラメータ
#
# message:: リクエストで受け取ったmessageパラメータ
#
get "/api/dummy/fail" do
  result = {
    status: STATUS_FAIL,
    error_cd: params["error_cd"],
    message: params["message"]
  }
  MultiJson.encode result
end

# リクエストされた内容をレスポンスに含めて返却します。POSTエラーテスト用
#
# == Request:
# error_cd:: レスポンスに含めたいerror_cd
#
# message:: レスポンスに含めたいmessage
#
# == Response JSON:
# status:: 常に1
#
# error_cd:: リクエストで受け取ったerror_cdパラメータ
#
# message:: リクエストで受け取ったmessageパラメータ
#
post "/api/dummy/fail" do
  result = {
    status: STATUS_FAIL,
    error_cd: params["error_cd"],
    message: params["message"]
  }
  MultiJson.encode result
end


post '/dummy/upload' do
  if params[:file]
    begin
      unless valid_image_extname(params[:file][:filename])
        return MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_UPLOAD_FILE_INVALID_EXTENTION, message: "Invalid file extention")
      end

      unless valid_file_size(File.size(params[:file][:tempfile]))
        return MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_UPLOAD_FILE_MAX_SIZE_EXCEED, message: "Max size exceeded: #{IMAGE_MAX_SIZE_MB}MB")
      end

      original = save_upload_file(params[:file][:tempfile], "test", "images")
      crop_image(original)
      url = remove_prefix_for_static_file(original).to_s
      return MultiJson.encode({status: STATUS_SUCCESS, data: {picture_url: url}})
    rescue => ex
      return MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_UPLOAD_FILE_UNEXPCTED_ERROR, message: ex.message)
    end
   else
    return MultiJson.encode(status: STATUS_FAIL, error_cd: ERR_CD_UPLOAD_FILE_NOT_FOUND, message: "Missing file")
  end
end
