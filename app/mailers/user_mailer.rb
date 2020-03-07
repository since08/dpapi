class UserMailer < ApplicationMailer
  def welcome(email, message, title)
    @message = message
    mail(to: email, subject: title)
  end
end
