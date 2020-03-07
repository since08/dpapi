module AcFactory
  class AcUs055 < AcBase

    def ac_us055_01
      order = generate_order
      order.update(permit_order_params)
    end

    def ac_us055_02
      user = User.by_email(params[:user])
      order = user.orders.first
      order.update(permit_order_params)
    end

    def permit_order_params
      params.permit(:price, :original_price)
    end
  end
end
