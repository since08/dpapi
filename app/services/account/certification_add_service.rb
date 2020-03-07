module Services
  module Account
    # rubocop:disable Metrics/LineLength: 130
    class CertificationAddService
      ID_REGEX = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/
      REAL_NAME_REGEX = /^[A-z]+$|^[\u4E00-\u9FA5]+$/
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Account
      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/MethodLength
      def call
        # 参数检查
        if user_params.blank? || user_params[:real_name].blank? || user_params[:cert_no].blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        user_params[:real_name].strip!
        user_params[:cert_no].strip!
        # 姓名检查
        return ApiResult.error_result(REAL_NAME_FORMAT_WRONG) unless check_real_name_format user_params[:real_name]

        # 身份证格式校验
        return ApiResult.error_result(CERT_NO_FORMAT_WRONG) unless check_card_format(user_params[:cert_type],
                                                                                     user_params[:cert_no])

        # 格式都正确
        extra_info = user.user_extra
        if extra_info.blank?
          user.create_user_extra!(user_params.merge(status: 'passed'))
          data = {
            user_extra: user.user_extra
          }
          return ApiResult.success_with_data(data)
        end

        if extra_info.cert_no.eql?(user_params[:cert_no]) && extra_info.status.eql?('passed')
          return ApiResult.error_result(CERT_NO_ALREADY_EXIST)
        end

        if extra_info.status.eql?('failed') || extra_info.status.eql?('init')
          extra_info.update!(user_params.merge(status: 'passed'))
        else
          extra_info.update!(user_params)
        end

        data = {
          user_extra: extra_info
        }
        ApiResult.success_with_data(data)
      end

      private

      def check_real_name_format(real_name)
        real_name =~ /^[A-z]+$|^[\u4E00-\u9FA5]+$/
      end

      def check_card_format(type, number)
        send "#{type}_format_true?", number
      end

      def chinese_id_format_true?(chinese_id)
        chinese_id =~ ID_REGEX
      end

      def passport_id_format_true?(_passport_id)
        true
      end
    end
  end
end
