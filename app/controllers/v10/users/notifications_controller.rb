module V10
  module Users
    class NotificationsController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        @notifications = @current_user.notifications.order(id: :desc).limit(30)
      end

      def unread_remind
        @unread_count = @current_user.notifications.where(read: false).count
        @recent_notification = @current_user.notifications.order(id: :desc).first
      end

      def read
        @current_user.notifications.find(params[:id]).update(read: true)
        render_api_success
      end

      def destroy
        @current_user.notifications.find(params[:id]).destroy
        render_api_success
      end
    end
  end
end
