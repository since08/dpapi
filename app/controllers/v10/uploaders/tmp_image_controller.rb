module V10
  module Uploaders
    class TmpImageController < ApplicationController
      include UserAccessible
      include Constants::Error::File
      before_action :login_required

      def create
        tmp_image = TmpImage.new(image: params[:image])
        if tmp_image.image.blank? || tmp_image.image.path.blank? || tmp_image.image_integrity_error.present?
          return render_api_error(FORMAT_WRONG)
        end
        return render_api_error(UPLOAD_FAILED) unless tmp_image.save
        template = 'v10/tmp_images/create'
        render template, locals: { image: tmp_image }
      end
    end
  end
end

