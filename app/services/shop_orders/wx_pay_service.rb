module Services
  module ShopOrders
    class WxPayService
      include Serviceable
      include Constants::Error::Order
      attr_accessor :order_number

      def initialize(order)
        @order = order
      end

      def call
        return ApiResult.error_result(CANNOT_PAY) unless @order.unpaid?

        result = WxPay::Service.invoke_unifiedorder(pay_params)
        unless result.success?
          # 微信统一下单失败
          Rails.logger.info("WX_PAY ERROR number=#{@order.order_number}: #{result}")
          return ApiResult.error_result(PAY_ERROR)
        end
        # 生成唤起支付需要的参数
        pay_result = generate_app_pay_req(result)
        ApiResult.success_with_data(pay_result: pay_result)
      end

      private

      def pay_params
        {
          body: "订单：#{@order.order_number}",
          out_trade_no: @order.order_number,
          total_fee: (@order.final_price * 100).to_i,
          spbill_create_ip: CurrentRequestCredential.client_ip,
          notify_url: notify_url,
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

      def notify_url
        "#{ENV['HOST_URL']}/v10/pay/wx_shop_order_notify"
      end
    end
  end
end
