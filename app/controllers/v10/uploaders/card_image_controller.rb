module V10
  module Uploaders
    class CardImageController < ApplicationController
      include UserAccessible
      include Constants::Error::File
      before_action :login_required

      def create
        @current_user.build_user_extra if @current_user.user_extra.nil?
        @current_user.user_extra.image = get_upload_file(upload_params[:image])
        # 检查文件格式
        if @current_user.user_extra.image.blank? || @current_user.user_extra.image.path.blank?
          return render_api_error(FORMAT_WRONG)
        end

        # 保存图片
        return render_api_error(UPLOAD_FAILED) unless @current_user.user_extra.save

        # 上传成功 返回数据
        template = 'v10/upload/image'
        render template, locals: { api_result: ApiResult.success_result, user_extra: @current_user.user_extra }
      end

      private

      def upload_params
        params.permit(:image)
      end

      def get_upload_file(target)
        return target if target
        UploadHelper.parse_file_format(env['rack.input'], env['CONTENT_TYPE'], @current_user.id)
      end
    end
  end
end

