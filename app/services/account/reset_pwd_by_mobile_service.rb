module Services
  module Account
    class ResetPwdByMobileService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :mobile, :vcode, :password

      def initialize(mobile, vcode, password)
        self.mobile = mobile
        self.vcode = vcode
        self.password = password
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      def call
        # 检查参数是否为空
        if mobile.blank? || vcode.blank? || password.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        # 检查密码是否符合规则
        unless UserValidator.pwd_valid?(password)
          return ApiResult.error_result(PASSWORD_FORMAT_WRONG)
        end

        # TODO: 验证逻辑需要移到新的验证码校验类
        # 检查验证码是否正确
        return ApiResult.error_result(VCODE_NOT_MATCH) unless VCode.check_vcode('reset_pwd', mobile, vcode)

        # 查询用户
        user = User.by_mobile(mobile)
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        # 创建新的用户密码
        salt = SecureRandom.hex(6).slice(0, 6)
        new_password = ::Digest::MD5.hexdigest("#{password}#{salt}")

        user.update(password: new_password, password_salt: salt)
        ApiResult.success_result
      end
    end
  end
end
