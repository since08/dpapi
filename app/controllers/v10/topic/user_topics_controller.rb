module V10
  module Topic
    class UserTopicsController < ApplicationController
      before_action :set_user_topic
      include UserAccessible
      before_action :login_required, only: [:likes, :image, :report]
      include Constants::Error::File

      def comments
        @comments = @user_topic.comments.order_show.page(params[:page]).per(params[:page_size])
      end

      def likes
        result = Services::Topic::CreateLikes.call(@user_topic, @current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'v10/topic/likes', locals: { topic: @user_topic }
      end

      def image
        @topic_image = UserTopicImage.new(image: params[:image], user_topic: @user_topic)
        if @topic_image.image.blank? || @topic_image.image.path.blank? || @topic_image.image_integrity_error.present?
          return render_api_error(FORMAT_WRONG)
        end
        return render_api_error(UPLOAD_FAILED) unless @topic_image.save
        render 'v10/topic/image'
      end

      def report
        @report = UserTopicReport.create(user_id: @user_topic.user.id,
                                         user_topic_id: @user_topic.id,
                                         report_user_id: @current_user.id,
                                         body: params[:body],
                                         report_type: @user_topic.body_type)

        @user_topic.counter.increment!(:reports)
        render 'v10/topic/report'
      end

      private

      def set_user_topic
        @user_topic = UserTopic.find(params[:id])
      end
    end
  end
end

