module V10
  module Account
    # 校验验证码是否正确
    class VerifyVcodesController < ApplicationController
      include Constants::Error::Sign
      include UserAccessible
      before_action :login_need?
      OPTION_TYPES = %w(register login reset_pwd change_pwd bind_account unbind_account
                        change_old_account bind_new_account bind_wx_account).freeze
      VCODE_TYPES = %w(mobile email).freeze
      include Constants::Error::Sign

      def create
        return render_api_error(VCODE_TYPE_WRONG) unless send_params[:vcode_type].in?(VCODE_TYPES)
        # 判断验证码验证的类型是否符合
        return render_api_error(UNSUPPORTED_OPTION_TYPE) unless send_params[:option_type].in?(OPTION_TYPES)
        vcode_verify_service = Services::Account::VcodeVerifyService
        api_result = vcode_verify_service.call(send_params[:option_type], gain_account, send_params[:vcode])
        render_api_error(api_result.code, api_result.msg)
      end

      private

      def send_params
        params.permit(:option_type, :vcode_type, :account, :vcode)
      end

      def login_need?
        if params[:option_type].eql?('change_old_account')
          login_required
        else
          @current_user = nil
        end
      end

      def gain_account
        if send_params[:option_type].eql?('change_old_account')
          @current_user[send_params[:vcode_type]]
        else
          send_params[:account]
        end
      end
    end
  end
end
