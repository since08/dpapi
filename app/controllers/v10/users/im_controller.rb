module V10
  module Users
    class ImController < ApplicationController
      include UserAccessible
      before_action :login_required
      include Constants::Error::Sign

      def report
        user = target_user
        return render_api_error(USER_NOT_FOUND) if user.blank?
        @report = UserTopicReport.create(user_id: user.id,
                                         report_user_id: @current_user.id,
                                         body: params[:body],
                                         description: params[:description].to_s,
                                         report_type: 'im')
        render 'v10/topic/report'
      end

      def target_user
        User.by_uuid(params[:reported_user_id])
      end
    end
  end
end

