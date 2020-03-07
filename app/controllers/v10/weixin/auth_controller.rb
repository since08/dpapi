module V10
  module Weixin
    class AuthController < ApplicationController
      before_action :set_wx_authorize
      include Constants::Error::Auth

      def create
        return render_api_error(AUTH_ERROR) unless @wx_authorize.is_valid?

        auth_service = Services::Weixin::AuthService
        api_result = auth_service.call(user_params, @wx_authorize)
        render_api_result(api_result)
      end

      private

      def set_wx_authorize
        @wx_authorize = WeixinAuthorize::Client.new(ENV['APP_ID'], ENV['APP_SECRET'])
      end

      def user_params
        params.permit(:code, :refresh_token)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/weixin/auth'
        render template, locals: { api_result: result,
                                   type: result.data[:type],
                                   data: result.data[:data] }
      end
    end
  end
end
