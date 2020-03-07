module V10
  module Topic
    class InfosController < ApplicationController
      before_action :set_info
      include UserAccessible
      before_action :login_required, only: [:likes]

      def comments
        @comments = @info.comments.order_show.page(params[:page]).per(params[:page_size])
        render :index
      end

      def likes
        result = Services::Topic::CreateLikes.call(@info, @current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'v10/topic/likes', locals: { topic: @info }
      end

      private

      def set_info
        @info = Info.find(params[:id])
      end
    end
  end
end

