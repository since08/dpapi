module V10
  module Topic
    class VideosController < ApplicationController
      before_action :set_video
      include UserAccessible
      before_action :login_required, only: [:likes]

      def comments
        @comments = @video.comments.order_show.page(params[:page]).per(params[:page_size])
        render :index
      end

      def likes
        result = Services::Topic::CreateLikes.call(@video, @current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'v10/topic/likes', locals: { topic: @video }
      end

      private

      def set_video
        @video = Video.find(params[:id])
      end
    end
  end
end