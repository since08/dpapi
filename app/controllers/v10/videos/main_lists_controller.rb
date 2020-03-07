module V10
  module Videos
    class MainListsController < ApplicationController
      def index
        page_size = permit_params[:page_size].blank? ? '10' : permit_params[:page_size]
        next_id = permit_params[:next_id].to_i <= 0 ? 1 : permit_params[:next_id].to_i
        type = VideoType.find(params[:type_id])
        # 开始分页
        videos = type.videos.where(is_main: true).order(created_at: :desc).page(next_id).per(page_size)
        top_video = type.videos.topped.first
        next_id += 1

        template = 'v10/videos/main_lists'
        render template, locals: { api_result: ApiResult.success_result,
                                   videos: videos,
                                   next_id: next_id,
                                   top_video: top_video }
      end

      private

      def permit_params
        params.permit(:page_size,
                      :next_id)
      end
    end
  end
end

