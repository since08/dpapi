module V10
  module Cf
    class PlayersController < ApplicationController
      include UserAccessible
      before_action :set_crowdfunding
      before_action :login_required, only: [:user_order_count]

      def index
        @players = @crowdfunding.crowdfunding_players.published.sorted.page(params[:page]).per(params[:page_size])
      end

      def show
        @player = @crowdfunding.crowdfunding_players.published.find(params[:id])
      end

      def reports
        @player = @crowdfunding.crowdfunding_players.published.find(params[:id])
        @reports = @player.crowdfunding_reports.page(params[:page]).per(params[:page_size])
      end

      def user_order_count
        @player = @crowdfunding.crowdfunding_players.published.find(params[:id])
        @count = CrowdfundingOrder.past_buy_number(@player, @current_user)
      end

      private

      def set_crowdfunding
        @crowdfunding = Crowdfunding.find(params[:crowdfunding_id])
      end
    end
  end
end

