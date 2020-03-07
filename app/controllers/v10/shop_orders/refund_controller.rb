module V10
  module ShopOrders
    class RefundController < ApplicationController
      include UserAccessible
      before_action :login_required

      def create
        order = ProductOrder.find_by!(order_number: params[:product_order_id])
        order_items = ProductOrderItem.find(params[:order_item_ids])
        refund_type = ProductRefundType.find(params[:product_refund_type_id])
        result = Services::ShopOrders::CreateRefundService.call(user_params, order_items, refund_type, order)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'v10/shop_order/refund/index', locals: { refund: result.data[:refund_record] }
      end

      private

      def user_params
        params.permit(:product_refund_type_id,
                      :refund_price,
                      :memo,
                      order_item_ids: [],
                      refund_images: [:id, :content])
      end
    end
  end
end

