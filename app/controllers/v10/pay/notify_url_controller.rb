module V10
  module Pay
    class NotifyUrlController < ApplicationController
      def create
        pay_bill_service = Services::Orders::PayBillService
        result = pay_bill_service.call(permit_params)
        render json: result
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

