module V10
  module Races
    class RacesController < ApplicationController
      # 获取赛事列表
      def index
        optional! :page_size, values: 0..100, default: 20
        api_result = if params[:filter_type] == 'web'
                       Services::Races::FilteredByWebService.call(filter_params)
                     else
                       Services::Races::FilteredByAppService.call(filter_params)
                     end
        render_api_result(api_result)
      end

      # 获取赛事列表某一赛事详情
      def show
        @race = Race.find(params[:id])
        @user = User.by_uuid(params[:u_id])
        render 'v10/races/show'
      end

      private

      def filter_params
        params.permit(:page_size,
                      :seq_id,
                      :host_id,
                      :operator,
                      :u_id,
                      :category,
                      :date)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        RenderResultHelper.render_races_result(self, result)
      end
    end
  end
end
