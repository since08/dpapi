module V10
  module ShopOrders
    class RefundRecordController < ApplicationController
      include UserAccessible
      before_action :login_required

      def index
        refund_record = ProductRefund.find_by!(refund_number: params[:refund_id])
        render 'v10/shop_order/refund/index', locals: { refund: refund_record }
      end
    end
  end
end
