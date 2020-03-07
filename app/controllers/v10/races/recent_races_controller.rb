module V10
  module Races
    # 获取主页赛事列表
    class RecentRacesController < ApplicationController
      include Constants::Error::Common
      def index
        api_result = Services::Races::RaceRecentService.call(params[:u_id], race_params[:number])
        render_api_result api_result
      end

      private

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/races/recent'
        RenderResultHelper.render_recent_race(self, template, result)
      end

      def race_params
        params.permit(:number)
      end
    end
  end
end
