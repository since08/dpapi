module V10
  module Players
    # 牌手信息部分
    class FollowsController < ApplicationController
      include Constants::Error::Common
      include UserAccessible

      before_action :set_player, :login_required

      def create
        follow = PlayerFollow.find_by(player_id: @player.id, user_id: @current_user.id)
        new_follow = PlayerFollow.new(user: @current_user, player: @player)
        if follow || new_follow.save
          render_api_success
        else
          render_api_error SYSTEM_ERROR
        end
      end

      def destroy
        follow = PlayerFollow.find_by!(player_id: @player.id, user_id: @current_user.id)
        follow.destroy
        render_api_success
      end

      def set_player
        @player = Player.find_by!(player_id: params[:player_id])
      end
    end
  end
end

