module AcFactory
  class AcUs056 < AcBase
    def ac_us056_01
      order = generate_order
      order.update(status: params[:order_status])
      user = User.last
      user.user_extra.update(status: 'passed')
    end
  end
end
