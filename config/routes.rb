Rails.application.routes.draw do
  get 'posts/index'

  get 'status/index'
  root 'status#index'

  devise_for :users

  namespace :api do
  namespace :v1 do
    	resources :posts do
        collection do
          get  'volumen', :action => 'volumen'
          post 'create', :action => 'new'
        end
    	end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
