module V10
  module Users
    class TopicNotificationsController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        @notifications = @current_user.topic_notifications
                                      .order(id: :desc)
                                      .page(params[:page])
                                      .per(params[:page_size])
        # 将消息全部置为已读
        @notifications.each(&:read!)
      end

      def unread_count
        @unread_count = @current_user.topic_notifications.where(read: false).count
      end

      def destroy
        @current_user.topic_notifications.find(params[:id]).destroy
        render_api_success
      end
    end
  end
end

