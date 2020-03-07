module V10
  module Topic
    class RepliesController < ApplicationController
      include UserAccessible
      include Constants::Error::Comment

      before_action :login_required, only: [:create, :destroy]
      before_action :set_comment
      before_action :set_reply, only: [:destroy]

      def index
        @replies = @comment.replies
        render :index
      end

      def create
        result = Services::UserAuthCheck.call(@current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        result = params[:reply_id].present? ? parent_reply : parent_comment
        return render_api_error(result.code, result.msg) if result.failure?
        render 'create', locals: { reply: result.data[:reply] }
      end

      def destroy
        unless @current_user.user_uuid.eql?(@reply.user.user_uuid)
          return render_api_error(CANNOT_DELETE)
        end
        @reply.destroy
        render_api_success
      end

      private

      def set_comment
        @comment = Comment.find(params[:comment_id])
      end

      def set_reply
        reply_id = params[:id] || params[:reply_id]
        @reply = @comment.replies.find_by!(id: reply_id)
      end

      def user_params
        params.permit(:body)
      end

      def parent_comment
        Services::Replies::CreateReplyService.call(user_params, @current_user, @comment)
      end

      def parent_reply
        Services::Replies::CreateReplyService.call(user_params, @current_user, @comment, set_reply)
      end
    end
  end
end
