module V10
  module Account
    # 修改密码
    class ChangePasswordsController < ApplicationController
      CHANGE_PWD_TYPE = %w(vcode pwd).freeze
      include UserAccessible
      include Constants::Error::Sign
      before_action :login_required, :user_self_required

      def create
        return render_api_error(UNSUPPORTED_OPTION_TYPE) unless user_params[:type].in?(CHANGE_PWD_TYPE)
        send("change_pwd_by_#{user_params[:type]}")
      end

      private

      def change_pwd_by_vcode
        change_pwd_service = Services::Account::ChangePwdByVcodeService
        api_result = change_pwd_service.call(user_params[:new_pwd],
                                             user_params[:mobile],
                                             user_params[:vcode],
                                             @current_user)
        render_api_result api_result
      end

      def change_pwd_by_pwd
        change_pwd_service = Services::Account::ChangePwdByPwdService
        api_result = change_pwd_service.call(user_params[:new_pwd], user_params[:old_pwd], @current_user)
        render_api_result api_result
      end

      def user_params
        params.permit(:type, :new_pwd, :old_pwd, :vcode, :mobile)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?
        render_api_success
      end
    end
  end
end
