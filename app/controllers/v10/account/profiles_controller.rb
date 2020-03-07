module V10
  module Account
    # 个人中心 个人信息部分
    class ProfilesController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def show
        # 获取用户信息
        template = 'v10/account/users/base'
        RenderResultHelper.render_user_result(self, template, @current_user)
      end

      def update
        # 修改用户个人信息
        user_params = user_permit_params.dup
        user_modified = Services::Account::ModifyProfileService.call(@current_user, user_params)

        template = 'v10/account/users/base'
        RenderResultHelper.render_user_result(self, template, user_modified)
      end

      private

      def user_permit_params
        params.permit(:nick_name, :gender, :birthday, :signature)
      end
    end
  end
end
