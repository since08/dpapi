module V10
  module Topic
    class CommentsController < ApplicationController
      include UserAccessible
      include Constants::Error::Comment
      before_action :login_required
      before_action :set_comment, only: [:destroy]

      def create
        result = Services::UserAuthCheck.call(@current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        result = Services::Comments::CreateCommentService.call(user_params, @current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'index', locals: { comment: result.data[:comment] }
      end

      def destroy
        unless @current_user.user_uuid.eql?(@comment.user.user_uuid)
          return render_api_error(CANNOT_DELETE)
        end
        @comment.destroy
        render_api_success
      end

      private

      def user_params
        params.permit(:topic_type,
                      :topic_id,
                      :body)
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end
    end
  end
end

