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
    
    zisterne_alert(volumen['volumen'], @user.id)

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
    def zisterne_alert(volume, user_id)
      
      #TODO: move Zisternen Volume to Database
      percent_zis = volume.to_f.percent_of(4500)
      
      #get last alert value
      la = Alerts.select("last_alert").last_alert(user_id).first
      
      #check which alert needs to be send
      if not la
        lap = 100
      else 
        lap = la.last_alert.to_i
      end
      
      limits = Array.new
      limits = [5,10,25,50,75,100]

      alert = alert_value(percent_zis, lap, limits)
      logger.info alert
      
      #create new alert in the db or update database with the last alert
      if not la
        a = Alerts.new
        a.user_id = user_id
        a.last_alert = alert       
        a.save!
        
        #send alert mail
        AlertMailer.alert_email("Alert", alert, @user.email).deliver_now
        
      elsif lap.to_i != alert.to_i
        Alerts.last_alert(user_id).update_all(last_alert: alert)        
        
        #send alert mail
        if lap.to_i > alert.to_i
          AlertMailer.alert_email("Achtung", alert, volume, @user.email).deliver_now
        else
          AlertMailer.alert_email("Hinweis", limits[limits.index(alert.to_i)-1], volume, @user.email).deliver_now
        end
      end
    end

    #define the alert value
    def alert_value(percent_zis, lap, limits)
      limits.each do |i|
        if percent_zis < i and lap != percent_zis
          alert = i.to_s
          break alert
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