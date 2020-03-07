module Services
  module Races
    class RaceRecentService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :number, :user_uuid

      def initialize(user_uuid, number)
        self.user_uuid = user_uuid
        self.number = number
      end

      def call
        nums = number.nil? ? '10' : number
        unless nums =~ /^[0-9]+$/
          return ApiResult.error_result(PARAM_FORMAT_ERROR)
        end
        ApiResult.success_with_data(race: Race.limit_recent_races(nums), user: User.by_uuid(user_uuid))
      end
    end
  end
end
