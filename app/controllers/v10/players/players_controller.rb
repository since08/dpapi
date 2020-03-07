module V10
  module Players
    # 牌手信息部分
    class PlayersController < ApplicationController
      include Constants::Error::Common
      include UserAccessible

      ALLOWED_REGIONS = %w(global domestic).freeze

      def index
        optional! :page_size, values: 0..100, default: 20
        optional! :page_index, default: 0
        optional! :region, values: ALLOWED_REGIONS, default: 'global'
        @offset = params[:page_size].to_i * params[:page_index].to_i
        @players = Services::Players::FilteringService.call(params)
      end

      def show
        @user = current_user
        @player = Player.find_by!(player_id: params[:id])
      end
    end
  end
end

