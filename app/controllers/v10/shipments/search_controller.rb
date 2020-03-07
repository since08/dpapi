module V10
  module Shipments
    class SearchController < ApplicationController
      include Constants::Error::Common

      def index
        express_code = params[:express_code]
        shipping_number = params[:shipping_number]
        order_number = params[:order_number]
        express = ExpressCode.find_by!(express_code: express_code)
        return render_api_error(MISSING_PARAMETER) if express_code.blank? || shipping_number.blank?
        shipments = Kuaidiniao::Service.get_trace(express_code, shipping_number, order_number)
        template = 'v10/shipments/search/index'
        render template, locals: { shipments: shipments, express: express }
      end
    end
  end
end

