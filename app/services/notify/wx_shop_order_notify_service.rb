module Services
  module Notify
    class WxShopNotifyNotifyService
      include Serviceable
      include Constants::Error::Order

      def initialize(order_result)
        Rails.logger.info "wx notify: #{order_result}"
        @order_result  = order_result
        @product_order = ProductOrder.find_by!(order_number: order_result['out_trade_no'])
      end

      def call
        # 验证签名是否正确
        unless sign_correct?
          Rails.logger.info "WX_PAY FAIL, 验证签名错误: #{@order_result}"
          return error_result('验证签名失败')
        end

        return ApiResult.success_result if repeated_notify?

        # 判断请求是否成功
        return error_result('微信交易失败') unless transaction_success?

        # 检查订单是否存在，订单的金额是否和数据库一致
        return error_result('订单金额不匹配') unless result_accord_with_order?

        order_to_paid
        # 记录的微信账单
        ProductWxBill.create(bill_params)
        ApiResult.success_result
      end

      private

      def repeated_notify?
        wx_bill_exists? && @product_order.paid?
      end

      def wx_bill_exists?
        ProductWxBill.exists?(transaction_id: @order_result['transaction_id'])
      end

      def transaction_success?
        @order_result['return_code'].eql?('SUCCESS') && @order_result['result_code'].eql?('SUCCESS')
      end

      def sign_correct?
        WxPay::Sign.verify?(@order_result)
      end

      def result_accord_with_order?
        (@product_order.final_price * 100).to_i == @order_result['total_fee'].to_i
      end

      def order_to_paid
        @product_order.update(status: 'paid', pay_status: 'paid') if @product_order.unpaid?
      end

      def error_result(msg)
        ApiResult.error_result(INVALID_ORDER, msg)
      end

      def bill_params
        { bank_type: @order_result['bank_type'],
          cash_fee: @order_result['cash_fee'],
          fee_type: @order_result['fee_type'],
          is_subscribe: @order_result['is_subscribe'],
          mch_id: @order_result['mch_id'],
          open_id: @order_result['openid'],
          product_order: @product_order,
          result_code: @order_result['result_code'],
          return_code: @order_result['return_code'],
          time_end: @order_result['time_end'],
          total_fee: @order_result['total_fee'],
          trade_type: @order_result['trade_type'],
          transaction_id: @order_result['transaction_id'] }
      end
    end
  end
end