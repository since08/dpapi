module Services
  module Notify
    class WxNotifyService
      include Serviceable
      attr_accessor :order_result

      def initialize(order_result)
        self.order_result = order_result
      end

      def call
        # 记录回调日志
        create_bill(create_params(order_result))

        # 判断请求是否成功
        return api_result('FAIL', '请求不成功') unless success?(order_result)

        # 返回的请求成功 验证签名
        unless sign_success?(order_result)
          Rails.logger.info 'wx_pay status: FAIL, 签名失败'
          return api_result('FAIL', '签名失败')
        end

        # 检查订单是否存在，订单的金额是否和数据库一致
        unless check_order(order_result)
          Rails.logger.info 'wx_pay status: FAIL, 订单不存在或订单金额不匹配'
          return api_result('FAIL', '订单不存在或订单金额不匹配')
        end

        # 更改订单的状态为已支付
        change_order_status(order_result)

        # 返回商户操作成功通知
        api_result('SUCCESS', 'OK')
      end

      private

      def success?(result)
        result['return_code'].eql?('SUCCESS') && result['result_code'].eql?('SUCCESS')
      end

      def sign_success?(result)
        WxPay::Sign.verify?(result)
      end

      def check_order(result)
        order = order_info(result)
        order.present?
      end

      def change_order_status(result)
        order = order_info(result)
        order.paid! if order.present? && order.unpaid?
      end

      def order_info(result)
        order_number = result['out_trade_no']
        PurchaseOrder.find_by(order_number: order_number)
      end

      def api_result(code, msg)
        {
          return_code: code,
          return_msg: msg
        }
      end

      def create_params(result)
        { appid: result['appid'],
          bank_type: result['bank_type'],
          cash_fee: result['cash_fee'],
          fee_type: result['fee_type'],
          is_subscribe: result['is_subscribe'],
          mch_id: result['mch_id'],
          open_id: result['openid'],
          out_trade_no: result['out_trade_no'],
          result_code: result['result_code'],
          return_code: result['return_code'],
          time_end: result['time_end'],
          total_fee: result['total_fee'],
          trade_type: result['trade_type'],
          transaction_id: result['transaction_id'] }
      end

      def create_bill(hash_result)
        # 商户号不存在的情况下才会写入
        return true if WxBill.exists?(transaction_id: hash_result[:transaction_id])
        WxBill.create(hash_result)
      end
    end
  end
end