module V10
  module Races
    class RaceTicketsController < ApplicationController
      def index
        optional! :page_size, values: 0..100, default: 20
        api_result = Services::Races::PurchasableRaceService.call(filter_params)
        render_api_result(api_result)
      end

      def filter_params
        params.permit(:page_size,
                      :seq_id,
                      :keyword)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        RenderResultHelper.render_races_result(self, result)
      end
    end
  end
end
