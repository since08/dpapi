module Services
  module V20
    module Account
      # rubocop:disable Metrics/LineLength
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/MethodLength
      class CertificationAddService
        ID_REGEX = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/
        REAL_NAME_REGEX = /^[A-z]+$|^[\u4E00-\u9FA5]+$/
        CERT_TYPES = %w(chinese_id passport_id).freeze
        include Serviceable
        include Constants::Error::File
        include Constants::Error::Common
        include Constants::Error::Account
        attr_accessor :user, :user_params

        def initialize(user, user_params)
          self.user = user
          self.user_params = user_params
        end

        def call
          # 参数检查 姓名，证件类型，证件号不能为空
          if user_params[:real_name].blank? || user_params[:cert_type].blank? || user_params[:cert_no].blank?
            return ApiResult.error_result(MISSING_PARAMETER)
          end

          # 检查证件类型
          unless CERT_TYPES.include?(user_params[:cert_type])
            return ApiResult.error_result(CERT_TYPE_INVALID)
          end

          user_params[:real_name].strip!
          user_params[:cert_no].strip!
          # 姓名检查
          return ApiResult.error_result(REAL_NAME_FORMAT_WRONG) unless check_real_name_format user_params[:real_name]

          # 证件格式校验
          return ApiResult.error_result(CERT_NO_FORMAT_WRONG) unless check_card_format(user_params[:cert_type],
                                                                                       user_params[:cert_no])
          # 查询证件是否已经被认证过了 认证过了的不能再次认证
          # if UserExtra.where(cert_no: user_params[:cert_no]).where(status: 'passed').exists?
          #   return ApiResult.error_result(CERT_NO_ALREADY_EXIST)
          # end

          # 判断是创建数据 还是修改数据
          return update_extra(user_params, user) if user_params[:extra_id].present?

          # 一个用户提交过一个实名审核，则只能修改，不能创建，护照同理 [未来如果做可以多实名，去掉这行就可以了]
          # return ApiResult.error_result(SINGLE_CERTIFICATION) if single_certification?(user, user_params)

          # 检查该用户是否提交过身份证实名
          return ApiResult.error_result(CERT_NO_TWICE) if cert_no_exist?(user, user_params)

          new_user_extra(user_params, user)
        end

        private

        # 修改实名
        def update_extra(data, user)
          extra_id = data[:extra_id]
          user_extra = UserExtra.find(extra_id)
          # 审核通过的状态不可以修改
          return ApiResult.error_result(CANNOT_UPDATE) if user_extra.status.eql?('passed')
          # 不可修改证件类型
          return ApiResult.error_result(CANNOT_UPDATE_CERT_TYPE) unless user_extra[:cert_type].eql?(data[:cert_type])
          # 查询对应的用户是否是当前用户 如果不是则没有权限修改
          return ApiResult.error_result(INVALID_OPTION) unless user.user_uuid.eql?(user_extra.user.user_uuid)
          new_user_extra(data, user, user_extra)
        end

        def new_user_extra(data, user, user_extra = nil)
          user_extra ||= UserExtra.new
          # 图片处理
          if data[:image].present?
            user_extra.image = data[:image]
            if user_extra.image.blank? || user_extra.image.path.blank? || user_extra.image_integrity_error.present?
              return ApiResult.error_result(FORMAT_WRONG)
            end
            return ApiResult.error_result(UPLOAD_FAILED) unless user_extra.save
          end
          # 准备创建数据
          user_extra.assign_attributes(user: user,
                                       real_name: data[:real_name],
                                       cert_no: data[:cert_no],
                                       cert_type: data[:cert_type],
                                       memo: data[:memo],
                                       status: 'pending')
          user_extra.save!

          # 返回实名后的数据列表
          ApiResult.success_with_data(user_extra: user_extra)
        end

        def get_upload_file(target)
          return target if target
          UploadHelper.parse_file_format(env['rack.input'], env['CONTENT_TYPE'], @current_user.id)
        end

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

        def single_certification?(user, user_params)
          cert_type = user_params[:cert_type]
          user.user_extras.where(cert_type: cert_type).exists?
        end

        def cert_no_exist?(user, user_params)
          user.user_extras.where(cert_no: user_params[:cert_no]).where(is_delete: 0).exists?
        end
      end
    end
  end
end
