#encoding: utf-8
require 'openssl'
require 'digest/md5'
module Helpers
  module SecurityHelper
    def md5(s)
      return Digest::MD5.new.update("#{s}#{Sinatra::Application.settings.hash_key}").to_s
    end

    def encrypt(msg, pass, salt="saltsalt")
      enc  = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
      enc.encrypt
      enc.pkcs5_keyivgen(pass, salt)
      return enc.update(msg) + enc.final
    end

    def decrypt(crypt_msg, pass, salt)
      dec = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
      dec.decrypt
      dec.pkcs5_keyivgen(pass, salt)
      dec.update(crypt_msg) + dec.final
    end
  end
end

helpers do
  include Helpers::SecurityHelper
end
