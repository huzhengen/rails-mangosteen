class UserMailer < ApplicationMailer
  def welcome_email(code)
    @code = code
    mail(to: "huzhengennn@163.com", subject: "hi")
  end
end
