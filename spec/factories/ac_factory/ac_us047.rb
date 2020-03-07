module AcFactory
  class AcUs047 < AcBase
    def ac_us047_01
      order = generate_order
      order.update(status: params[:order_status])
    end
  end
end