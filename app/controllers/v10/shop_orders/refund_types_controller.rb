module V10
  module ShopOrders
    class RefundTypesController < ApplicationController
      include UserAccessible
      before_action :login_required

      def index
        @types = ProductRefundType.all
        render 'v10/shop_order/refund_types/index'
      end
    end
  end
end
