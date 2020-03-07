module V10
  module News
    class SearchController < ApplicationController
      def index
        page_size = permit_params[:page_size].blank? ? '10' : permit_params[:page_size]
        next_id = permit_params[:next_id].to_i <= 0 ? 1 : permit_params[:next_id].to_i
        keyword = permit_params[:keyword].blank? ? '' : permit_params[:keyword]

        news_all = Info.where('title like ? or source like ?', "%#{keyword}%", "%#{keyword}%")
                       .limit(page_size)
                       .order(date: :desc).order(created_at: :desc)
                       .page(next_id).per(page_size)

        # 去掉类别为未发布的资讯
        news = news_all.reject { |item| item.info_type.blank? }

        next_id += 1
        template = 'v10/news/search'
        render template, locals: { api_result: ApiResult.success_result,
                                   news: news,
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

