module Services
  module Account
    class BindAccountService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      def call
        account = user_params[:account]
        type = user_params[:type]
        # 判断验证码是否匹配
        unless check_code('bind_account', account, user_params[:code])
          return ApiResult.error_result(VCODE_NOT_MATCH)
        end

        send("update_#{type}", account)
      end

      private

      def check_code(type, account, code)
        return true if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?
        VCode.check_vcode(type, account, code)
      end

      def update_mobile(mobile)
        # 判断手机号格式是否正确
        return ApiResult.error_result(MOBILE_FORMAT_WRONG) unless UserValidator.mobile_valid?(mobile)
        # 判断账户是否存在
        return ApiResult.error_result(MOBILE_ALREADY_USED) if UserValidator.mobile_exists?(mobile)

        # 更新账户
        user.assign_attributes(mobile: mobile)
        user.updated_at = Time.zone.now
        user.touch_visit!
        # 记录一次账户修改
        Common::DataStatCreator.create_account_change_stats(user, 'mobile')
        ApiResult.success_with_data(user: user)
      end

      def update_email(email)
        # 检查邮箱格式是否正确
        return ApiResult.error_result(EMAIL_FORMAT_WRONG) unless UserValidator.email_valid?(email)
        # 检查邮箱是否存在
        return ApiResult.error_result(EMAIL_ALREADY_USED) if UserValidator.email_exists?(email)

        # 更新账户
        user.assign_attributes(email: email)
        user.updated_at = Time.zone.now
        user.touch_visit!
        # 记录一次账户修改
        Common::DataStatCreator.create_account_change_stats(user, 'email')
        ApiResult.success_with_data(user: user)
      end
    end
  end
end
