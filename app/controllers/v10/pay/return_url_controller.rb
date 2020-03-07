module V10
  module Pay
    class ReturnUrlController < ApplicationController
      def create
        pay_bill_service = Services::Orders::PayBillService
        pay_bill_service.call(permit_params)
        redirect_to ENV['RETURN_H5_URL']
      end

      private

      def permit_params
        params.permit(:Version,
                      :MerchantId,
                      :MerchOrderId,
                      :Amount,
                      :ExtData,
                      :OrderId,
                      :Status,
                      :PayTime,
                      :SettleDate,
                      :Sign)
      end
    end
  end
end

