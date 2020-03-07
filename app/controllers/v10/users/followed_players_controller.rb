module V10
  module Users
    class FollowedPlayersController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        optional! :page_size, values: 0..100, default: 20
        params[:next_id] = 10**15 if params[:next_id].to_i.zero?

        @followed_players = @current_user.followed_players
                                         .where('id < ?', params[:next_id].to_i)
                                         .limit(params[:page_size])
      end
    end
  end
end
