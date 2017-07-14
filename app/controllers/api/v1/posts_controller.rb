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

end
