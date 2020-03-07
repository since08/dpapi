module V10
  module Uploaders
    # 上传用户头像
    class AvatarController < ApplicationController
      include UserAccessible
      include Constants::Error::File
      before_action :login_required

      def create
        @current_user.avatar = get_upload_file(upload_params[:avatar])
        # 检查文件格式
        if @current_user.avatar.blank? || @current_user.avatar.path.blank? || @current_user.avatar_integrity_error.present?
          return render_api_error(FORMAT_WRONG)
        end
        # 保存图片
        return render_api_error(UPLOAD_FAILED) unless @current_user.save
        # 上传成功 返回数据
        template = 'v10/account/users/base'
        RenderResultHelper.render_user_result(self, template, @current_user)
      end

      private

      def upload_params
        params.permit(:avatar)
      end

      def get_upload_file(target)
        return target if target
        UploadHelper.parse_file_format(ENV['rack.input'], ENV['CONTENT_TYPE'], @current_user.id)
      end
    end
  end
end
