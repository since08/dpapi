module V10
  module Races
    class SearchByKeywordController < ApplicationController
      include Constants::Error::Common
      def index
        optional! :page_size, values: 0..100, default: 30
        api_result = Services::Races::SearchByKeywordService.call(search_params)
        render_api_result(api_result)
      end

      private

      def search_params
        params.permit(:keyword, :seq_id, :page_size, :u_id)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        RenderResultHelper.render_races_result(self, result)
      end
    end
  end
end

