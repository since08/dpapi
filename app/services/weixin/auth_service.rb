module Services
  module Weixin
    class AuthService
      include Serviceable
      include Constants::Error::Auth
      attr_accessor :user_params, :wx_authorize

      def initialize(user_params, wx_authorize)
        self.user_params = user_params
        self.wx_authorize = wx_authorize
      end

      def call
        # 拿到用户传递过来的code
        code = user_params[:code]

        # 新增 获取用户传过来的refresh_token
        # 如果用户传了refresh_token 那么就直接通过refresh_token去拿token
        refresh_token = user_params[:refresh_token]
        token_result = refresh_token.blank? ? access_token(code) : refresh_token(refresh_token)

        # 获取access_token和open_id
        # token_result = access_token(code) # 废弃
        return ApiResult.error_result(AUTH_ERROR) unless token_result.code.zero?
        token_result = token_result.result

        # 拿到用户的信息
        wx_user = wx_user_info(token_result[:openid], token_result[:access_token])
        return ApiResult.error_result(AUTH_ERROR) unless wx_user.code.zero?
        wx_user = wx_user.result

        wx_user.merge! token_result
        check_wx_user(wx_user)
      end

      private

      def access_token(code)
        token_result = wx_authorize.get_oauth_access_token(code)
        Rails.logger.info "wx_authorize_token_result: #{token_result.as_json}"
        token_result
      end

      def refresh_token(token)
        token_result = wx_authorize.refresh_oauth2_token(token)
        Rails.logger.info "wx_authorize_refresh_token_result: #{token_result.as_json}"
        token_result
      end

      def wx_user_info(open_id, access_token)
        user_info = wx_authorize.get_oauth_userinfo(open_id, access_token)
        Rails.logger.info "wx_authorize_user_info: #{user_info.as_json}"
        user_info
      end

      def check_wx_user(wx_user)
        w_user = WeixinUser.find_by(open_id: wx_user[:openid])
        w_user.nil? ? record_data(wx_user) : return_data(w_user)
      end

      def record_data(data)
        # 数据库中没有该用户的记录
        create_weixin_user(data)
        # 返回access_token, open_id等信息给前端
        return_access_token(data[:access_token])
      end

      def return_data(data)
        # 判断该记录是否有绑定过用户，如果有记录但是没有绑定用户，那么返回access_token给前端
        user = data.user
        return return_access_token(data[:access_token]) if user.nil?

        # 刷新上次访问时间
        user.touch_visit!

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        ApiResult.success_with_data(login_result(user, access_token))
      end

      def return_access_token(access_token)
        ApiResult.success_with_data(type: 'register', data: { access_token: access_token })
      end

      def create_weixin_user(data)
        create_params = { open_id: data[:openid],
                          nick_name: data[:nickname],
                          sex: data[:sex],
                          province: data[:province],
                          city: data[:city],
                          country: data[:country],
                          head_img: data[:headimgurl],
                          privilege: JSON(data[:privilege]),
                          union_id: data[:unionid],
                          access_token: data[:access_token],
                          expires_in: data[:expires_in],
                          refresh_token: data[:refresh_token] }
        WeixinUser.create(create_params)
      end

      def login_result(user, access_token)
        {
          type: 'login',
          data: { user: user,
                  access_token: access_token }
        }
      end
    end
  end
end
