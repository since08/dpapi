module Services
  module Account
    class VcodeVerifyService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Sign
      attr_accessor :type, :account, :vcode

      def initialize(type, account, vcode)
        self.type = type
        self.account = account
        self.vcode = vcode
      end

      def call
        return ApiResult.error_result(MISSING_PARAMETER) if account.blank?
        self.account = account.downcase

        # 检查验证码是否正确
        return ApiResult.error_result(VCODE_NOT_MATCH) unless VCode.check_vcode(type, account, vcode)

        # 验证码正确
        ApiResult.success_result
      end
    end
  end
end
