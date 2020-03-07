module Services
  module Replies
    class CreateReplyService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Comment

      def initialize(params, user, comment, reply = nil)
        @params = params
        @user = user
        @comment = comment
        @reply = reply
      end

      def call
        return ApiResult.error_result(BODY_BLANK) unless @params[:body].to_s.strip.length.positive?
        return ApiResult.error_result(ILLEGAL_KEYWORDS) if Services::FilterHelp.illegal?(@params[:body])
        reply_user_id = @reply.present? ? @reply.user.id : @comment.user.id
        reply = @comment.replies.create!(user: @user,
                                         body: @params[:body],
                                         topic: @comment.topic,
                                         reply: @reply,
                                         reply_user_id: reply_user_id)
        ApiResult.success_with_data(reply: reply)
      end
    end
  end
end
