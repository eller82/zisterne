class Api::V1::PostsController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user

  def index
    posts = Volumen.all
    render json: {status: 'SUCCESS', message: 'Loaded all posts', data: posts}, status: :ok
  end

  def volumen
  end

  def new
    #logger.info @user.id
    @post = render json: params[:post]
    parsed_post = JSON.parse @post

    volumen = parsed_post['volumen']
    entfernung = parsed_post['entfernung']

    neu = Volumen.new(volumen)
    if neu.save
      @status = ":created"
    else
      @status = ":conflict"
    end

    neu = Entfernung.new(entfernung)
    if neu.save
      @status = ":created"
    else
      @status = ":conflict"
    end
    
    zisterne_alert(volumen['volumen'])

  end

  def show
  end


  private
    def authenticate_user
      user_token = request.headers['X-USER-TOKEN']
      if user_token
        @user = User.find_by_token(user_token)
        #Unauthorize if a user object is not returned
        if @user.nil?
          return unauthorize
        end
      else
        return unauthorize
      end
    end

    def unauthorize
      #head status: :unauthorized
      self.status = :unauthorized
      self.response_body = { error: 'Access denied' }.to_json
      return false
    end

    #alerts for Zisterne Volume
    def zisterne_alert(volume)
      
      percent_zis = volume.to_f.percent_of(4500)
      
      #get last alert value
      la = Alerts.select("last_alert").last_alert(1).first
      
      #check which alter needs to be send
      if not la
        lap = 100
      else 
        lap = la.last_alert.to_i
      end
      
      #logger.info lap
      #logger.info percent_zis
      
      if percent_zis < 5 and lap != percent_zis
        alert = "5"
      elsif percent_zis < 10 and lap != percent_zis
        alert = "10"
      elsif percent_zis < 25 and lap != percent_zis
        alert = "25"        
      elsif percent_zis < 50 and lap != percent_zis
        alert = "50"        
      elsif percent_zis < 75  and lap != percent_zis
        alert = "75"        
      else
        alert = 100
      end
      
      #update database with the last alert
      if not la
        a = Alerts.new
        a.user_id = 1
        a.last_alert = alert       
        a.save!
        
        #send alert mail
        AlertMailer.alert_email("Alert", alert).deliver_now
        
      elsif lap.to_i != alert.to_i
        Alerts.last_alert(1).update_all(last_alert: alert)        
        
        #send alert mail
        if lap.to_i > alert.to_i
          AlertMailer.alert_email("Alert", alert).deliver_now
        else
          AlertMailer.alert_email("Hinweis", alert).deliver_now
        end
      end

    end

end

#geklaut von: https://stackoverflow.com/questions/3668345/calculate-percentage-in-ruby
class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end
