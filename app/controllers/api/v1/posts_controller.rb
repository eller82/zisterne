class Api::V1::PostsController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user

  def index
    posts = Volumen.all
    render json: {status: 'SUCCESS', message: 'Loaded all posts', data: posts}, status: :ok
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
