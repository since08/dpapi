module Services
  module Account
    class CertificationService
      include Serviceable
      include Constants::Error::Account
      attr_accessor :user

      def initialize(user)
        self.user = user
      end

      def call
        user_extra = user.user_extra
        return ApiResult.error_result(NO_CERTIFICATION) if user_extra.nil?
        ApiResult.success_with_data(user_extra: user_extra)
      end
    end
  end
end
