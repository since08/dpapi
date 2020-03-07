module AcFactory
  class AcUs044 < AcBase

    def ac_us044
      generate_order
    end

    def ac_us044_03
      update_order_status
    end

    def ac_us044_04
      update_order_status
    end

    def ac_us044_05
      update_order_status
    end

    def ac_us044_06
      update_order_status
    end

    def update_order_status
      user = User.by_email(params[:user])
      order = user.orders.first
      order.update(status: params[:status])
    end

  end
end
