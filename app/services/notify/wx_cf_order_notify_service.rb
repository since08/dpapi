module Services
  module Notify
    class WxCfNotifyNotifyService
      include Serviceable
      include Constants::Error::Order

      def initialize(order_result)
        Rails.logger.info "wx notify: #{order_result}"
        @order_result = order_result
        @cf_order = CrowdfundingOrder.find_by!(order_number: order_result['out_trade_no'])
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
        WxBill.create(bill_params)
        @cf_order.crowdfunding_player.counter.quick_increment!(@cf_order)

        # ricky-2018-03-13添加扑客币抵扣相关逻辑
        if @cf_order.deduction
          PokerCoin.deduction(@cf_order, '众筹抵扣扑客币', @cf_order.deduction_numbers)
          @cf_order.deduction_success
        end

        ApiResult.success_result
      end

      private

      def repeated_notify?
        @cf_order.paid?
      end

      def wx_bill_exists?
        WxBill.exists?(transaction_id: @order_result['transaction_id'])
      end

      def transaction_success?
        @order_result['return_code'].eql?('SUCCESS') && @order_result['result_code'].eql?('SUCCESS')
      end

      def sign_correct?
        WxPay::Sign.verify?(@order_result)
      end

      def result_accord_with_order?
        (@cf_order.final_price * 100).to_i == @order_result['total_fee'].to_i
      end

      def order_to_paid
        @cf_order.update(paid: true, pay_time: Time.now)
      end

      def error_result(msg)
        ApiResult.error_result(INVALID_ORDER, msg)
      end

      def bill_params
        { appid: @order_result['appid'],
          bank_type: @order_result['bank_type'],
          cash_fee: @order_result['cash_fee'],
          fee_type: @order_result['fee_type'],
          is_subscribe: @order_result['is_subscribe'],
          mch_id: @order_result['mch_id'],
          open_id: @order_result['openid'],
          out_trade_no: @order_result['out_trade_no'],
          result_code: @order_result['result_code'],
          return_code: @order_result['return_code'],
          time_end: @order_result['time_end'],
          total_fee: @order_result['total_fee'],
          trade_type: @order_result['trade_type'],
          transaction_id: @order_result['transaction_id'],
          bill_type: 'crowdfunding' }
      end
    end
  end
end