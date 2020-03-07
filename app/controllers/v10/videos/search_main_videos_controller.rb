module V10
  module Videos
    class SearchMainVideosController < ApplicationController
      def index
        page_size = permit_params[:page_size].blank? ? '10' : permit_params[:page_size]
        next_id = permit_params[:next_id].to_i <= 0 ? 1 : permit_params[:next_id].to_i
        keyword = permit_params[:keyword].blank? ? '' : permit_params[:keyword]

        videos_all = Video.where(is_main: true)
                          .where('name like ?', "%#{keyword}%")
                          .limit(page_size)
                          .order(created_at: :desc)
                          .page(next_id).per(page_size)

        # 去掉类别为未发布的video
        videos = videos_all.reject { |item| item.video_type.blank? }

        next_id += 1
        template = 'v10/videos/search_main_videos'
        render template, locals: { api_result: ApiResult.success_result,
                                   videos: videos,
                                   next_id: next_id }
      end

      private

      def permit_params
        params.permit(:page_size,
                      :next_id,
                      :keyword)
      end
    end
  end
end