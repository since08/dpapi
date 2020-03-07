# 改变登录账户
module V10
  module Account
    class ChangeAccountController < ApplicationController
      ACCOUNT_TYPES = %w(mobile email).freeze
      include Constants::Error::Sign
      include UserAccessible
      before_action :login_required, :user_self_required

      def create
        user_params = permit_params.dup

        unless ACCOUNT_TYPES.include?(user_params[:type])
          return render_api_error(UNSUPPORTED_TYPE)
        end

        if user_params[:account].blank? || user_params[:old_code].blank? || user_params[:new_code].blank?
          return render_api_error(MISSING_PARAMETER)
        end

        change_account_service = Services::Account::ChangeAccountService
        api_result = change_account_service.call(@current_user, user_params)
        render_api_result api_result
      end

      private

      def permit_params
        params.permit(:type,      # 重置账户的类型
                      :account,   # 账户
                      :old_code,  # 旧的验证码
                      :new_code)  # 新的验证码
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/account/users/base'
        RenderResultHelper.render_user_result(self, template, result.data[:user])
      end
    end
  end
end

