module V10
  module Races
    class SearchRangeListController < ApplicationController
      include Constants::Error::Common
      def index
        begin_date = search_params[:begin_date]
        end_date = search_params[:end_date]
        if begin_date.blank? || end_date.blank?
          return render_api_error(MISSING_PARAMETER)
        end
        api_result = Services::Races::SearchRangeListService.call(params[:u_id], search_params)
        render_api_result api_result
      end

      private

      def search_params
        params.permit(:begin_date, :end_date)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/races/search_range_list/index'
        render template, locals: { api_result:  result,
                                   race: result.data[:race] }
      end
    end
  end
end

