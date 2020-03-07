module V10
  module Cf
    class WxPayController < ApplicationController
      include UserAccessible
      before_action :login_required, :set_order

      def create
        pay_order_service = Services::CrowdfundingOrders::WxPayService
        api_result = pay_order_service.call(@order)
        render_api_result api_result
      end

      private

      def set_order
        @order = CrowdfundingOrder.find_by!(user_id: @current_user, order_number: params[:crowdfunding_order_id])
      end

      def render_api_result(api_result)
        return render_api_error(api_result.code, api_result.msg) if api_result.failure?

        template = 'v10/orders/orders/wx_pay'
        render template, locals: { api_result: ApiResult.success_result, order: api_result.data[:pay_result] }
      end
    end
  end
end
