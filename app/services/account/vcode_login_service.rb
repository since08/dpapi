module Services
  module Account
    class VcodeLoginService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign
      include Constants::Error::Http

      attr_accessor :mobile, :vcode, :remote_ip

      def initialize(mobile, vcode, remote_ip)
        self.mobile = mobile
        self.vcode = vcode
        self.remote_ip = remote_ip
      end

      def call
        # 验证码或手机号是否为空
        return ApiResult.error_result(MISSING_PARAMETER) if mobile.blank? || vcode.blank?

        # 查询用户是否存在
        user = User.by_mobile(mobile)
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        # 检查用户输入的验证码是否正确
        return ApiResult.error_result(VCODE_NOT_MATCH) unless VCode.check_vcode('login', mobile, vcode)

        # 查询用户是否被被禁访问
        return ApiResult.error_result(HTTP_USER_BAN) if user.banned?

        # 刷新上次访问时间
        user.touch_visit!

        user.touch_login_ip!(remote_ip)

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
