module V10
  module Players
    # 牌手信息部分
    class RanksController < ApplicationController
      include Constants::Error::Common

      def index
        player = Player.find_by!(player_id: params[:player_id])
        @ranks = player.race_ranks.limit(50)
      end
    end
  end
end

