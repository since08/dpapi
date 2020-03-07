module V10
  module Orders
    class PayController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def create
        order_id = params[:order_id]
        pay_order_service = Services::Orders::PayOrderService
        api_result = pay_order_service.call(order_id)
        render_api_result api_result
      end

      private

      def render_api_result(api_result)
        return render_api_error(api_result.code, api_result.msg) if api_result.failure?

        template = 'v10/orders/orders/pay'
        render template, locals: { api_result: ApiResult.success_result, order: api_result.data[:pay_result] }
      end
    end
  end
end
