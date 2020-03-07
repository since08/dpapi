module AcFactory
  class AcUs019 < AcBase

    def ac_us019_03
      user = User.by_email(params[:email])
      Services::Orders::CreateOrderService.call(Race.first, user, email: params[:email])
    end
  end
end
