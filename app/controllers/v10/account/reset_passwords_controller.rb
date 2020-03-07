module V10
  module Account
    class ResetPasswordsController < ApplicationController
      RESET_TYPES = %w(mobile email).freeze
      include Constants::Error::Sign

      def create
        reset_params = permit_reset_params.dup
        reset_type = reset_params.delete(:type)

        unless RESET_TYPES.include?(reset_type)
          return render_api_error(UNSUPPORTED_RESET_TYPE)
        end

        send("reset_pwd_by_#{reset_type}", reset_params)
      end

      private

      def permit_reset_params
        params.permit(:type,      # 重置密码的方式
                      :mobile,    # 手机
                      :email,     # 邮箱
                      :password,  # 新的密码
                      :vcode)     # 验证码
      end

      def reset_pwd_by_mobile(reset_params)
        reset_pwd_service = Services::Account::ResetPwdByMobileService
        api_result = reset_pwd_service.call(reset_params['mobile'], reset_params['vcode'], reset_params['password'])
        render_api_result api_result
      end

      def reset_pwd_by_email(reset_params)
        reset_pwd_service = Services::Account::ResetPwdByEmailService
        api_result = reset_pwd_service.call(reset_params['email'], reset_params['vcode'], reset_params['password'])
        render_api_result api_result
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?
        render_api_success
      end
    end
  end
end
