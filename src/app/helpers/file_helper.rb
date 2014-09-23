#encoding: utf-8
require 'sinatra/base'
require "open-uri"
require 'fileutils'
require 'RMagick'
module Helpers
  module FileHelper
    def save_download_file(url, filename, path)
      file_name = File.basename(filename)
      save_file = "static/#{path}/#{file_name}"
      open(save_file, 'wb') {|output|
        open(url) {|data|
          output.write(data.read)
        }
      }
      save_file
    end

    def save_upload_file(file, filename, path)
      new_filename = filename + DateTime.now.strftime('%s')
      save_file = "static/#{path}/#{new_filename}"
      File.open(save_file, 'wb') {|f|
        f.write(file.read)
      }
      save_file
    end

    def crop_image(file)
      original = Magick::Image.read(file).first
      is_wider  = original.x_resolution.to_i > IMAGE_THUMBNAIL_WIDTH
      is_higher = original.y_resolution.to_i > IMAGE_THUMBNAIL_HEIGHT

      croped =
        if (is_wider && is_higher)
          original.crop(Magick::CenterGravity, IMAGE_THUMBNAIL_WIDTH, IMAGE_THUMBNAIL_HEIGHT)
        elsif (is_wider)
          original.crop(Magick::CenterGravity, IMAGE_THUMBNAIL_WIDTH, original.y_resolution.to_i)
        elsif (is_higher)
          original.crop(Magick::CenterGravity, original.x_resolution.to_i, IMAGE_THUMBNAIL_HEIGHT)
        else
          original
        end
      croped.write("#{file}_thumbnail")
    end

    def valid_image_extname(uploadfile, *available)
      ([".JPG", ".JPEG", ".PNG", ".BMP", ".GIF"] + available).include?(File.extname(uploadfile).upcase)
    end

    def valid_file_size(size)
      size <= IMAGE_MAX_SIZE_MB * 1024 * 1024
    end

    def remove_prefix_for_static_file(path)
      path.slice!("static")
      path
    end
  end
end

helpers do
  include Helpers::FileHelper
end
