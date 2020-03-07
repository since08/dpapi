module Services
  module Account
    class MobileLoginService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign
      include Constants::Error::Http

      attr_accessor :mobile, :password, :remote_ip

      def initialize(mobile, password, remote_ip)
        self.mobile = mobile
        self.password = password
        self.remote_ip = remote_ip
      end

      def call
        # 检查手机号格式是否正确
        return ApiResult.error_result(MISSING_PARAMETER) if mobile.blank? || password.blank?

        user = User.by_mobile(mobile)
        # 判断该用户是否存在
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        # 判断用户是否被禁用
        return ApiResult.error_result(HTTP_USER_BAN) if user.banned?

        salted_passwd = ::Digest::MD5.hexdigest(password + user.password_salt)
        unless salted_passwd.eql?(user.password)
          return ApiResult.error_result(PASSWORD_NOT_MATCH)
        end

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
