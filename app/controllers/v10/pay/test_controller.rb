module V10
  module Pay
    class TestController < ApplicationController
      def index
        params = {
          amount: 12,
          order_desc: '测试测试',
          client_ip: '192.168.2.10',
          merch_order_id: order_id,
          trade_time: trade_time,
          misc_data: '13922897656|0||张三|440121197511140912|62220040001154868428||PAYECO20151028543445||2|'
        }
        @result = JSON.parse(YlPay::Service.generate_order_url(params))
        template = 'v10/pay/test.json'
        render template
      end

      private

      def order_id
        '1220170808' + rand(1000..9999).to_s
      end

      def trade_time
        Time.now.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end

