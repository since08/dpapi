module V10
  module Races
    class OrdersController < ApplicationController
      include UserAccessible

      before_action :set_race, :set_ticket, :login_required

      def create
        result = Services::Orders::CreateOrderService.call(@race, @ticket, @current_user, params)
        return render_api_error(result.code, result.msg) if result.failure?

        @order = result.data[:order]
      end

      private

      def set_race
        @race = Race.find(params[:race_id])
      end

      def set_ticket
        @ticket = Ticket.find(params[:ticket_id])
      end
    end
  end
end
