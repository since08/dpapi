module Services
  module Comments
    class CreateCommentService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Comment

      def initialize(params, user)
        @params = params
        @user = user
      end

      def call
        return ApiResult.error_result(UNSUPPORTED_TYPE) unless topic_type_permit?
        return ApiResult.error_result(BODY_BLANK) unless @params[:body].to_s.strip.length.positive?
        return ApiResult.error_result(ILLEGAL_KEYWORDS) if Services::FilterHelp.illegal?(@params[:body])
        comment = @user.comments.create(topic: set_topic, body: @params[:body])
        ApiResult.success_with_data(comment: comment)
      end

      private

      def topic_type_permit?
        %w(info video user_topic).include?(@params[:topic_type])
      end

      def set_topic
        send("set_#{@params[:topic_type]}")
      end

      def set_info
        Info.find(@params[:topic_id])
      end

      def set_video
        Video.find(@params[:topic_id])
      end

      def set_user_topic
        UserTopic.find(@params[:topic_id])
      end
    end
  end
end
