module V10
  module Races
    class TicketStatusController < ApplicationController
      def show
        ticket_status_service = Services::Races::TicketStatusService
        api_result = ticket_status_service.call(params[:race_id])
        render_api_result api_result
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?
        render_api_success
      end
    end
  end
end

