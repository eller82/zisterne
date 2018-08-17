Rails.application.routes.draw do

  root 'status#index'

  get 'posts/index'

  get 'status/index'
  get '/chart', to: 'status#chart', as: 'chart'
  get '/chartdata/:dauer', to: 'status#chartdata', as: 'chartdata'

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
