module V10
  module Uploaders
    class UploadHelper
      def self.parse_file_format(string_file, file_type, user_id)
        san_file = CarrierWave::SanitizedFile.new(string_file)
        san_file.original_filename = "#{user_id}_tmp#{parse_ext_name(file_type)}"
        san_file
      end

      def self.parse_ext_name(file_type)
        case file_type
        when 'image/jpeg'
          '.jpg'
        when 'image/png'
          '.png'
        when 'image/gif'
          '.gif'
        else
          ''
        end
      end
    end
  end
end
