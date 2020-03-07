module Services
  module Orders
    class PayOrderService
      include Serviceable
      include Constants::Error::Order
      attr_accessor :order_number

      def initialize(order_number)
        self.order_number = order_number
      end

      def call
        return ApiResult.success_with_data(pay_result: '') unless Rails.env.production?

        order = PurchaseOrder.find_by!(order_number: order_number)
        return ApiResult.error_result(CANNOT_PAY) unless order.status == 'unpaid'
        pay_result = JSON.parse(YlPay::Service.generate_order_url(pay_params(order)))
        unless pay_result['code'] == '0000'
          # 支付失败
          Rails.logger.info "PAY ERROR: #{pay_result['code']}, msg: #{pay_result['msg']}"
          return ApiResult.error_result(PAY_ERROR)
        end
        # 支付成功
        ApiResult.success_with_data(pay_result: pay_result)
      end

      private

      def pay_params(order)
        {
          amount: order.final_price,
          order_desc: order.ticket.try(:title),
          client_ip: CurrentRequestCredential.client_ip,
          merch_order_id: order.order_number,
          trade_time: Time.now.strftime('%Y%m%d%H%M%S')
        }
      end
    end
  end
end
