module Services
  module Orders
    class PayBillService
      include Serviceable
      attr_accessor :send_params

      def initialize(send_params)
        self.send_params = send_params
      end

      def call
        send_params[:Sign].tr!(' ', '+')
        Rails.logger.info send_params.to_json
        trade_info = check_status(send_params['Status'])
        # 检查签名
        trade_info = { trade_status: 'E101', trade_msg: '验证签名失败' } unless check_sign(send_params)
        # 更改订单信息
        order = PurchaseOrder.find_by(order_number: send_params[:MerchOrderId])
        trade_info = { trade_status: 'E103', trade_msg: '订单号不存在' } if order.blank?
        # 订单确定支付成功 并且 订单存在 并且订单的状态是未支付才会去更新
        order.paid! if send_params['Status'].eql?('02') && order.present? && order.unpaid?
        # 创建订单
        create_bill(create_params(send_params, trade_info))
        trade_info
      end

      private

      def create_params(resource, trade_info)
        { merchant_id: resource[:MerchantId],
          order_number: resource[:MerchOrderId],
          amount: resource[:Amount],
          pay_time: resource[:PayTime],
          trade_number: resource[:OrderId],
          trade_code: resource[:Status] }.merge!(trade_info)
      end

      def create_bill(params)
        # 检查商户号是否存在，不存在的情况下才会写入
        return true if Bill.exists?(trade_number: params[:trade_number])
        bill = Bill.new(params)
        bill.save!
      end

      def check_status(status)
        if status.eql?('02')
          { trade_status: '0', trade_msg: '订单已支付' }
        else
          { trade_status: status, trade_msg: '订单支付失败 ' }
        end
      end

      def check_sign(params)
        YlPay::Service.check_notify_sign(params)
      end
    end
  end
end
