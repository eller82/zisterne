class AlertMailer < ApplicationMailer
  
  def alert_email(type, alert)
    @alert = alert
    @type = type
    mail(to: "andre.mellentin@gmail.com", subject: @type + ': Zisterne Mellentin')
  end
end
