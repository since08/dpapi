module AcFactory
  class AcUs069 < AcBase
    def ac_us069
      generate_order
      user = User.by_email(params[:user])
      user.user_extra.failed!
    end
  end
end