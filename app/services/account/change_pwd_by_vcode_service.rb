module Services
  module Account
    class ChangePwdByVcodeService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :new_pwd, :mobile, :vcode, :user

      def initialize(new_pwd, mobile, vcode, user)
        self.new_pwd = new_pwd
        self.mobile = mobile
        self.vcode = vcode
        self.user = user
      end

      def call
        # 检查密码是否为空
        if vcode.blank? || mobile.blank? || new_pwd.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        # 检查密码是否太简单
        unless UserValidator.pwd_valid?(new_pwd)
          return ApiResult.error_result(PASSWORD_FORMAT_WRONG)
        end

        # 判断验证码是否一致
        return ApiResult.error_result(VCODE_NOT_MATCH) unless VCode.check_vcode('change_pwd', mobile, vcode)

        # 生成新的密码 设置新的盐值
        new_salt = SecureRandom.hex(6).slice(0, 6)
        new_password = ::Digest::MD5.hexdigest("#{new_pwd}#{new_salt}")

        user.update(password: new_password, password_salt: new_salt)
        ApiResult.success_result
      end
    end
  end
end
