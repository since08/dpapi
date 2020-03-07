module Services
  module Account
    class ModifyProfileService
      include Serviceable
      include Constants::Error::Sign
      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      def call
        # 检查用户是否存在
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        user.assign_attributes(user_params)
        user.updated_at = Time.zone.now
        user.touch_visit!
        user
      end
    end
  end
end
