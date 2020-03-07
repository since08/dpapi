module V10
  module Races
    class UnpaidOrdersController < ApplicationController
      include UserAccessible

      before_action :set_race, :set_ticket, :login_required

      def show
        @order = @current_user.orders.where(race_id: @race.id)
                              .where(ticket_id: @ticket.id)
                              .find_by(status: :unpaid)
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
