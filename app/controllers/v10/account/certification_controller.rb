module V10
  module Account
    class CertificationController < ApplicationController
      CERT_TYPES = %w(chinese_id passport_id).freeze
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        params[:version].eql?('v20') ? v20_index : v10_index
      end

      def create
        params[:version].eql?('v20') ? v20_create : v10_create
      end

      private

      def v10_index
        certification_service = Services::Account::CertificationService
        api_result = certification_service.call(@current_user)
        return render_api_error(api_result.code, api_result.msg) if api_result.failure?
        template = 'v10/account/users/extra'
        RenderResultHelper.render_certification_result(self, template, api_result)
      end

      def v20_index
        chinese_ids = @current_user.user_extras.where(cert_type: 'chinese_id').where(is_delete: 0)
        passport_ids = @current_user.user_extras.where(cert_type: 'passport_id').where(is_delete: 0)
        template = 'v20/account/user_extras/index'
        render template, locals: { api_result: ApiResult.success_result,
                                   chinese_ids: chinese_ids, passport_ids: passport_ids }
      end

      def v10_create
        certification_add_service = Services::Account::CertificationAddService
        create_params = user_params.dup
        unless check_type(create_params[:cert_type])
          create_params[:cert_type] = 'chinese_id'
        end
        api_result = certification_add_service.call(@current_user, create_params)
        render_api_result api_result
      end

      def v20_create
        certification_add_service = Services::V20::Account::CertificationAddService
        create_params = user_params.dup
        # 处理图片
        create_params[:image] = get_upload_file(create_params[:image]) unless create_params[:image].blank?
        api_result = certification_add_service.call(@current_user, create_params)
        render_api_result api_result
      end

      def user_params
        params.permit(:extra_id,
                      :real_name,
                      :cert_no,
                      :cert_type,
                      :image,
                      :version)
      end

      def render_api_result(api_result)
        return render_api_error(api_result.code, api_result.msg) if api_result.failure?
        template = 'v10/account/users/extra'
        RenderResultHelper.render_certification_result(self, template, api_result)
      end

      def get_upload_file(target)
        return target if target
        UploadHelper.parse_file_format(env['rack.input'], env['CONTENT_TYPE'], @current_user.id)
      end

      # 新版上线后需要去掉这个
      def check_type(cert_type)
        CERT_TYPES.include?(cert_type)
      end
    end
  end
end

