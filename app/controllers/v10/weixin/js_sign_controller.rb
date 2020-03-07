module V10
  module Weixin
    class JsSignController < ApplicationController
      before_action :set_wx_authorize
      include Constants::Error::Auth

      def create
        return render_api_error(AUTH_ERROR) unless @wx_authorize.is_valid?
        @sign_package = @wx_authorize.get_jssign_package(params[:url])
        render 'v10/weixin/new'
      end

      private

      def set_wx_authorize
        @wx_authorize = WeixinAuthorize::Client.new(ENV['G_APP_ID'], ENV['G_APP_SECRET'])
      end
    end
  end
end

