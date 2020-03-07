module V10
  module Users
    class LoginCountController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def create
        # 访问次数加1
        User.increment_counter(:login_count, @current_user.id)
        @current_user.touch_visit!
        render_api_success
      end
    end
  end
end
