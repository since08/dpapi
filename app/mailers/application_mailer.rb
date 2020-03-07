class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_SENDER']
  default charset: 'utf-8'
  default content_type: 'text/html'
  layout 'mailer'
end
