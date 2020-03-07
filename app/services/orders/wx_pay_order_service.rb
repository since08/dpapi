module Services
  module Orders
    class WxPayOrderService
      include Serviceable
      include Constants::Error::Order
      attr_accessor :order_number

      def initialize(order_number)
        self.order_number = order_number
      end

      def call
        return ApiResult.success_with_data(pay_result: {}) unless Rails.env.production?

        order = PurchaseOrder.find_by!(order_number: order_number)
        return ApiResult.error_result(CANNOT_PAY) unless order.status == 'unpaid'
        result = WxPay::Service.invoke_unifiedorder(pay_params(order))
        unless result.success?
          # 微信统一下单失败
          Rails.logger.info("WX_PAY ERROR number=#{order.order_number}: #{result}")
          return ApiResult.error_result(PAY_ERROR)
        end
        # 生成唤起支付需要的参数
        pay_result = generate_app_pay_req(result)
        ApiResult.success_with_data(pay_result: pay_result)
      end

      private

      def pay_params(order)
        {
          body: order.ticket.try(:title),
          out_trade_no: order.order_number,
          total_fee: (order.final_price * 100).to_i,
          spbill_create_ip: CurrentRequestCredential.client_ip,
          notify_url: ENV['WX_NOTIFY_URL'],
          trade_type: 'APP'
        }
      end

      def generate_app_pay_req(result)
        params = {
          prepayid: result['prepay_id'],
          noncestr: result['nonce_str']
        }
        WxPay::Service.generate_app_pay_req params
      end
    end
  end
end
