module V10
  module Videos
    class TypesController < ApplicationController
      def index
        types = VideoType.all.order(level: :asc)

        template = 'v10/videos/index'
        render template, locals: { api_result: ApiResult.success_result,
                                   types: types }
      end

      def show
        page_size = permit_params[:page_size].blank? ? '10' : permit_params[:page_size]
        next_id = permit_params[:next_id].blank? ? '0' : permit_params[:next_id]
        type = VideoType.find(params[:id])
        top_new = type.videos.topped.first
        videos = next_id.eql?('0') ? get_start_page(type, page_size) : next_page(type, next_id, page_size)
        next_id = videos.last.try(:id) || 0

        template = 'v10/videos/show'
        render template, locals: { api_result: ApiResult.success_result,
                                   videos: videos,
                                   next_id: next_id,
                                   top_new: top_new }
      end

      private

      def permit_params
        params.permit(:page_size,
                      :next_id)
      end

      def get_start_page(type, page_size)
        type.videos.limit(page_size).order(id: :desc)
      end

      def next_page(type, next_id, page_size)
        type.videos.where('id < ?', next_id).limit(page_size).order(id: :desc)
      end
    end
  end
end