module AcFactory
  class AcUs053 < AcBase

    def ac_us053
      generate_order
    end

    def ac_us053_02
      update_order_status
    end

    def ac_us053_03
      update_order_status
    end

    def ac_us053_04
      update_order_status
    end

    def update_order_status
      user = User.by_email(params[:user])
      order = user.orders.first
      order.update(status: params[:status])
    end

  end
end
