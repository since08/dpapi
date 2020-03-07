# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength
module Services
  module Jmessage
    class CreateUser
      include Serviceable
      include Constants::Error::Common

      def initialize(user)
        @user = user
        @local_user = @user.j_user
      end

      def call
        # 尝试从极光获取用户信息
        @remote_user = ::Jmessage::User.user_info(@user.user_uuid)
        return ApiResult.success_with_data(j_user: @local_user) if user_exists?

        return ApiResult.error_result(SYSTEM_ERROR) if user_unnormal

        params = payload

        # 上传用户头像
        if @user.avatar_path.present?
          default_str_max = OpenURI::Buffer::StringMax
          buffer_limit(0)
          img_result = ::Jmessage::User.upload_image(open(@user.avatar_path))
          params[:avatar] = img_result['media_id'] if img_result['media_id'].present?
          buffer_limit(default_str_max)
        end

        # 去极光注册用户信息
        result = ::Jmessage::User.register(params)
        Rails.logger.info "Jmessage service result: -> #{result}"

        # 说明注册失败
        if result.first['error'].present?
          return ApiResult.error_result(result.first['error']['code'], result.first['error']['message']) if user.nil?
        end

        # 在数据库创建该用户信息
        j_user = JUser.create(user_id: @user.id, username: params[:username], password: params[:password])
        ApiResult.success_with_data(j_user: j_user)
      end

      def user_exists?
        local_user_exists? && remote_user_exists?
      end

      def local_user_exists?
        @local_user.present?
      end

      def remote_user_exists?
        @remote_user['error'].blank? ? true : false
      end

      def user_unnormal
        # 本地用户存在 远程不存在 或者 远程存在 本地不存在
        local_user_exists? != remote_user_exists?
      end

      def payload
        { username: @user.user_uuid,
          nickname: @user.nick_name,
          password: ::Digest::MD5.hexdigest(SecureRandom.uuid) }
      end

      def buffer_limit(number)
        OpenURI::Buffer.send :remove_const, 'StringMax' if string_max_defined?
        OpenURI::Buffer.const_set 'StringMax', number
      end

      def string_max_defined?
        OpenURI::Buffer.const_defined?('StringMax')
      end
    end
  end
end

