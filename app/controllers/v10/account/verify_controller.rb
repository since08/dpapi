module V10
  module Account
    class VerifyController < ApplicationController
      def index
        account = params[:account]
        flag = UserValidator.mobile_exists?(account) || UserValidator.email_exists?(account)
        template = 'v10/account/verify/index'
        render template, locals: { api_result: ApiResult.success_result,
                                   flag: flag }
      end
    end
  end
end

