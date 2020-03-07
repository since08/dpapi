module V10
  module Users
    class PokerCoinsController < ApplicationController
      include UserAccessible
      before_action :login_required

      def index
        @poker_coins = @current_user.poker_coins.page(params[:page]).per(params[:page_size])
      end

      def numbers
        @numbers = @current_user.counter.total_poker_coins
        @discount = PokerCoinDiscount.first.blank? ? 0 : PokerCoinDiscount.first.discount
      end
    end
  end
end

