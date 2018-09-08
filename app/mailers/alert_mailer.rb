class AlertMailer < ApplicationMailer
  
  def alert_email(type, alert, volume, user_mail)
    @alert = alert
    @type = type
    @volume = volume
    mail(to: user_mail, subject: @type + ': Zisterne Mellentin')
  end
end
