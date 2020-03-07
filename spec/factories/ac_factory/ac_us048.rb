module AcFactory
  class AcUs048 < AcBase
    def ac_us048_01
      order = generate_order
      order.update(permit_order_params)
    end

    def permit_order_params
      params.permit(:status)
    end
  end
end