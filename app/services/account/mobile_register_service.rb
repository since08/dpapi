module Services
  module Account
    class MobileRegisterService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :mobile, :vcode, :password, :remote_ip

      def initialize(params, remote_ip)
        self.mobile = params[:mobile]
        self.vcode = params[:vcode]
        self.password = params[:password]
        self.remote_ip = remote_ip || ''
      end

      def call
        # 检查手机格式是否正确
        return ApiResult.error_result(MOBILE_FORMAT_WRONG) unless UserValidator.mobile_valid?(mobile)

        # 检查验证码是否正确
        return ApiResult.error_result(VCODE_NOT_MATCH) unless VCode.check_vcode('register', mobile, vcode)

        # 检查手机号是否存在
        if UserValidator.mobile_exists?(mobile)
          return ApiResult.error_result(MOBILE_ALREADY_USED)
        end

        # 检查密码是否合法
        if password.present? && !UserValidator.pwd_valid?(password)
          return ApiResult.error_result(PASSWORD_FORMAT_WRONG)
        end

        # 可以注册, 创建一个用户
        user = User.create_by_mobile(mobile, password, remote_ip)

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        # 记录一次账户修改
        Common::DataStatCreator.create_account_change_stats(user, 'mobile')
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
