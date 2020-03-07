module V10
  module Account
    # 负责登录相关的业务逻辑
    class SessionsController < ApplicationController
      LOGIN_TYPES = %w(email vcode mobile).freeze
      include Constants::Error::Common

      def create
        login_type = params[:type]
        unless LOGIN_TYPES.include?(login_type)
          return render_api_error(UNSUPPORTED_TYPE)
        end
        send("login_by_#{login_type}")
      end

      private

      def login_by_vcode
        vcode_service = Services::Account::VcodeLoginService
        api_result = vcode_service.call(login_params[:mobile], login_params[:vcode], request.remote_ip)
        render_api_result api_result
      end

      def login_by_email
        email_service = Services::Account::EmailLoginService
        api_result = email_service.call(login_params[:email], login_params[:password], request.remote_ip)
        render_api_result api_result
      end

      def login_by_mobile
        mobile_service = Services::Account::MobileLoginService
        api_result = mobile_service.call(login_params[:mobile], login_params[:password], request.remote_ip)
        render_api_result api_result
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/account/users/session'
        RenderResultHelper.render_session_result(self, template, result)
      end

      def login_params
        params.permit(:type, :mobile, :email, :vcode, :password)
      end
    end
  end
end
