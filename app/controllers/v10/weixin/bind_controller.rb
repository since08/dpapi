module V10
  module Weixin
    class BindController < ApplicationController
      ACCOUNT_TYPES = %w(mobile email).freeze
      include Constants::Error::Sign
      before_action :set_wx_authorize

      def create
        user_params = permit_params.dup

        unless ACCOUNT_TYPES.include?(user_params[:type])
          return render_api_error(UNSUPPORTED_TYPE)
        end

        bind_service = Services::Weixin::BindService
        api_result = bind_service.call(user_params, @wx_authorize)
        render_api_result(api_result)
      end

      private

      def set_wx_authorize
        @wx_authorize = WeixinAuthorize::Client.new(ENV['APP_ID'], ENV['APP_SECRET'])
      end

      def permit_params
        params.permit(:type, :account, :code, :access_token, :password)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/account/users/session'
        RenderResultHelper.render_session_result(self, template, result)
      end
    end
  end
end

