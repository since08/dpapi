module Services
  module Account
    class VcodeServices
      COMMON_SMS_TEMPLATE = '您的验证码是：%s，请不要把验证码泄漏给其他人。'.freeze
      RESET_PWD_SMS_TEMPLATE = '您的验证码是：%s，您申请重置本站的登录密码，请勿将验证码泄露给任何人。'.freeze
      REGISTER_SMS_TITLE = '请激活您的帐号，完成注册'.freeze
      RESET_PWD_TITLE = '重设您的密码'.freeze
      COMMON_SMS_TITLE = '扑客验证码'.freeze

      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      def call
        vcode_type = user_params[:vcode_type]
        option_type = user_params[:option_type]

        # 检查是否传了手机号或者邮箱
        account_id = gain_account_id(option_type, vcode_type)
        return ApiResult.error_result(MISSING_PARAMETER) if account_id.blank?

        sms_template = send_template(option_type)

        api_result = check_permission(option_type, account_id)
        if api_result.failure?
          api_result
        else
          send("send_#{vcode_type}_vcodes", option_type, sms_template, account_id)
        end
      end

      private

      def send_mobile_vcodes(option_type, sms_template, account_id)
        return ApiResult.error_result(MOBILE_FORMAT_WRONG) unless UserValidator.mobile_valid?(account_id)
        vcode = VCode.generate_mobile_vcode(option_type, account_id)
        sms_content = format(sms_template, vcode)
        Rails.logger.info "send [#{sms_content}] to #{account_id} in queue"
        # 测试则不实际发出去
        return ApiResult.success_result if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?

        SendMobileSmsJob.set(queue: 'send_mobile_sms').perform_later(option_type, account_id, sms_content)
        ApiResult.success_result
      end

      def send_email_vcodes(option_type, sms_template, account_id)
        return ApiResult.error_result(EMAIL_FORMAT_WRONG) unless UserValidator.email_valid?(account_id)
        account_id = account_id.downcase
        vcode = VCode.generate_email_vcode(option_type, account_id)
        sms_content = format(sms_template, vcode)
        Rails.logger.info "send [#{sms_content}] to #{account_id} in queue"
        sms_title = send_title(option_type)
        # 测试则不实际发出去
        return ApiResult.success_result if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?

        SendEmailSmsJob.set(queue: 'send_email_sms').perform_later(option_type, account_id, sms_content, sms_title)
        ApiResult.success_result
      end

      def send_template(option_type)
        option_type.eql?('reset_pwd') ? RESET_PWD_SMS_TEMPLATE : COMMON_SMS_TEMPLATE
      end

      def send_title(option_type)
        if option_type == 'register'
          REGISTER_SMS_TITLE
        elsif option_type == 'reset_pwd'
          RESET_PWD_TITLE
        else
          COMMON_SMS_TITLE
        end
      end

      def check_permission(option_type, account_id)
        # 注册和绑定的时候要求用户不存在
        if option_type.in?(%w(register bind_account bind_new_account)) && check_user_exist(account_id)
          return ApiResult.error_result(USER_ALREADY_EXIST)
        end

        # 其它情况都要求用户已存在
        unless option_type.in?(%w(register bind_account bind_new_account bind_wx_account)) || check_user_exist(account_id)
          return ApiResult.error_result(USER_NOT_FOUND)
        end

        ApiResult.success_result
      end

      def check_user_exist(account_id)
        User.by_email(account_id).present? || User.by_mobile(account_id).present?
      end

      def gain_account_id(option_type, vcode_type)
        if option_type.eql?('change_old_account')
          user[:"#{vcode_type}"]
        else
          user_params[:"#{vcode_type}"]
        end
      end
    end
  end
end
