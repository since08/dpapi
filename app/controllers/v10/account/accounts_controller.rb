module V10
  module Account
    # 处理注册相关的业务逻辑
    class AccountsController < ApplicationController
      ALLOW_TYPES = %w(email mobile).freeze
      include Constants::Error::Common

      def create
        register_type = params[:type]
        unless ALLOW_TYPES.include?(register_type)
          return render_api_error(UNSUPPORTED_TYPE)
        end
        send("register_by_#{register_type}")
      end

      private

      def register_by_mobile
        mobile_register_service = Services::Account::MobileRegisterService
        api_result = mobile_register_service.call(user_params, request.remote_ip)
        render_api_result api_result
      end

      def register_by_email
        email_register_service = Services::Account::EmailRegisterService
        api_result = email_register_service.call(user_params, request.remote_ip)
        render_api_result api_result
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/account/users/session'
        RenderResultHelper.render_session_result(self, template, result)
      end

      def user_params
        params.permit(:type, :email, :mobile, :password, :vcode)
      end
    end
  end
end
