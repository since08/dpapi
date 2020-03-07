module AcFactory
  class AcUs050 < AcBase
    def ac_us050_01
      order = generate_order
      order.update(status: params[:order_status])
    end
  end
end