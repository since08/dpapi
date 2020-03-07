module Services
  module Weixin
    class BindService
      include Serviceable
      include Constants::Error::Http
      include Constants::Error::Auth
      include Constants::Error::Sign
      include Constants::Error::Common

      attr_accessor :user_params, :wx_authorize

      def initialize(user_params, wx_authorize)
        self.user_params = user_params
        self.wx_authorize = wx_authorize
      end

      def call
        # 验证手机验证码是否正确
        account = user_params[:account]
        unless check_code('bind_wx_account', account, user_params[:code])
          return ApiResult.error_result(VCODE_NOT_MATCH)
        end
        access_token = user_params[:access_token]

        # 从数据库找到该用户的记录
        wx_user = WeixinUser.find_by(access_token: access_token)

        # 如果找不到记录，说明传递过来的access_token是错误的
        return ApiResult.error_result(NOT_FOUND) if wx_user.nil?

        # 判断该微信是否有绑定过其它用户
        return ApiResult.error_result(ALREADY_BIND) if wx_user.user.present?

        # 查看该手机号是否注册过
        user = User.by_mobile(account)

        user.nil? ? create_user(user_params, wx_user) : bind_user(user, wx_user)
      end

      private

      def check_code(type, account, code)
        return true if Rails.env.to_s.eql?('test') || ENV['AC_TEST'].present?
        VCode.check_vcode(type, account, code)
      end

      def create_user(user_params, wx_user)
        password = user_params[:password]
        if password.present? && !UserValidator.pwd_valid?(password)
          return ApiResult.error_result(PASSWORD_FORMAT_WRONG)
        end

        # 可以注册, 创建一个用户
        user = User.create_by_mobile(user_params[:account], password)
        gender = wx_user[:sex].to_i.eql?(1) ? 1 : 0
        user.update(nick_name: wx_user[:nick_name], wx_avatar: wx_user[:head_img], gender: gender)

        # 绑定用户
        bind_wx_user(user, wx_user)
      end

      def bind_user(user, wx_user)
        # 查看用户是否绑定过其它微信
        return ApiResult.error_result(ACCOUNT_ALREADY_BIND) if user.weixin_user.present?

        # 查看用户是否被封禁
        return ApiResult.error_result(HTTP_USER_BAN) if user.banned?

        # 更新用户头像到用户表里面
        user.update(wx_avatar: wx_user[:head_img])

        bind_wx_user(user, wx_user)
      end

      def bind_wx_user(user, wx_user)
        # 绑定该微信到该用户
        wx_user.update(user_id: user.id)

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        # 记录一次账户修改
        Common::DataStatCreator.create_account_change_stats(user, 'mobile')
        Account::LoginResultHelper.call(user, access_token)
      end
    end
  end
end
