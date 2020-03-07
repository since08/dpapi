# rubocop:disable Metrics/MethodLength
module Services
  module Account
    class EmailLoginService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign
      include Constants::Error::Http

      attr_accessor :email, :password, :remote_ip

      def initialize(email, password, remote_ip)
        self.email = email
        self.password = password
        self.remote_ip = remote_ip
      end

      def call
        # 验证密码和邮箱是否为空
        if email.blank? || password.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end
        self.email = email.downcase
        user = User.by_email(email)
        # 判断该用户是否存在
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        # 判断用户是否被禁用
        return ApiResult.error_result(HTTP_USER_BAN) if user.banned?

        # 查询出了这个用户 对比密码
        salted_passwd = ::Digest::MD5.hexdigest(password + user.password_salt)
        unless salted_passwd.eql?(user.password)
          return ApiResult.error_result(PASSWORD_NOT_MATCH)
        end

        # 刷新上次访问时间
        user.touch_visit!

        # 刷新上次访问ip
        user.touch_login_ip!(remote_ip)

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
