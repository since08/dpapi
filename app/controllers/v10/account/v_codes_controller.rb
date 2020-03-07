module V10
  module Account
    # 发送验证码的接口
    class VCodesController < ApplicationController
      include Constants::Error::Sign
      include UserAccessible
      before_action :login_need?
      OPTION_TYPES = %w(register login reset_pwd change_pwd bind_account unbind_account
                        change_old_account bind_new_account bind_wx_account).freeze

      VCODE_TYPES = %w(mobile email).freeze
      include Constants::Error::Sign

      def create
        return render_api_error(VCODE_TYPE_WRONG) unless user_params[:vcode_type].in?(VCODE_TYPES)
        return render_api_error(UNSUPPORTED_OPTION_TYPE) unless user_params[:option_type].in?(OPTION_TYPES)
        api_result = Services::Account::VcodeServices.call(@current_user, user_params)
        render_api_error(api_result.code, api_result.msg)
      end

      private

      def user_params
        params.permit(:option_type, :vcode_type, :mobile, :email)
      end

      def login_need?
        if params[:option_type].eql?('change_old_account')
          login_required
        else
          @current_user = nil
        end
      end
    end
  end
end
