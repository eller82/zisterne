class AlertMailer < ApplicationMailer
  
  def alert_email(type, alert, user_mail)
    @alert = alert
    @type = type
    mail(to: user_mail, subject: @type + ': Zisterne Mellentin')
  end
end
