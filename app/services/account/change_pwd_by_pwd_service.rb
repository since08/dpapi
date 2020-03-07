module Services
  module Account
    class ChangePwdByPwdService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :new_pwd, :old_pwd, :user

      def initialize(new_pwd, old_pwd, user)
        self.new_pwd = new_pwd
        self.old_pwd = old_pwd
        self.user = user
      end

      def call
        # 检查密码是否为空
        if old_pwd.blank? || new_pwd.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        # 检查密码是否太简单
        unless UserValidator.pwd_valid?(new_pwd)
          return ApiResult.error_result(PASSWORD_FORMAT_WRONG)
        end

        # 判断输入的密码是否和之前设定的是一致的
        old_salt = user.password_salt
        old_salted_password = ::Digest::MD5.hexdigest("#{old_pwd}#{old_salt}")
        unless user.password.eql?(old_salted_password)
          return ApiResult.error_result(PASSWORD_NOT_MATCH)
        end

        # 生成新的密码 设置新的盐值
        new_salt = SecureRandom.hex(6).slice(0, 6)
        new_password = ::Digest::MD5.hexdigest("#{new_pwd}#{new_salt}")

        user.update(password: new_password, password_salt: new_salt)
        ApiResult.success_result
      end
    end
  end
end
