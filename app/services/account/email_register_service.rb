module Services
  module Account
    class EmailRegisterService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :email, :password, :remote_ip

      def initialize(params, remote_ip)
        self.email = params[:email].downcase
        self.password = params[:password]
        self.remote_ip = remote_ip
      end

      def call
        # 检查邮箱格式是否正确
        unless UserValidator.email_valid?(email)
          return ApiResult.error_result(EMAIL_FORMAT_WRONG)
        end

        # 检查邮箱是否存在
        if UserValidator.email_exists?(email)
          return ApiResult.error_result(EMAIL_ALREADY_USED)
        end

        # 检查密码是否合法
        unless UserValidator.pwd_valid?(password)
          return ApiResult.error_result(PASSWORD_FORMAT_WRONG)
        end

        # 可以注册, 创建一个用户
        user = User.create_by_email(email, password, remote_ip)

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        # 记录一次账户修改
        Common::DataStatCreator.create_account_change_stats(user, 'email')
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
