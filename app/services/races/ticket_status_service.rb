module Services
  module Races
    class TicketStatusService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Race
      attr_accessor :race_id

      def initialize(race_id)
        self.race_id = race_id
      end

      def call
        race = Race.find(race_id)
        case race.ticket_status
        when 'unsold'
          return ApiResult.error_result(TICKET_UNSOLD)
        when 'end'
          return ApiResult.error_result(TICKET_END)
        when 'sold_out'
          return ApiResult.error_result(TICKET_SOLD_OUT)
        when 'selling'
          ApiResult.success_result
        else
          return ApiResult.error_result(DATABASE_ERROR)
        end
      end
    end
  end
end
