#encoding: utf-8

IMAGE_MAX_SIZE_MB      = 10
IMAGE_THUMBNAIL_WIDTH  = 230
IMAGE_THUMBNAIL_HEIGHT = 160

#----------------------------------
# Response status
#----------------------------------
STATUS_SUCCESS     = 0
STATUS_FAIL        = 1
STATUS_MAINTENANCE = 2


#----------------------------------
# Error CDs
#----------------------------------
# Common errors
ERR_CD_UNEXPECTED_ERROR      = 1000
ERR_CD_INVALID_REQUEST_PARAM = 1001
ERR_CD_404                   = 1002
ERR_CD_403                   = 1003
ERR_CD_500                   = 1004

# Upload erros
ERR_CD_UPLOAD_FILE_NOT_FOUND         = 7001
ERR_CD_UPLOAD_FILE_MAX_SIZE_EXCEED   = 7002
ERR_CD_UPLOAD_FILE_INVALID_EXTENTION = 7003
ERR_CD_UPLOAD_FILE_UNEXPCTED_ERROR   = 7004
