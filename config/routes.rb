Rails.application.routes.draw do

  root to: 'query_definitions#index'

  resources :query_definitions do
    resource :search_keys, only: [:update, :destroy], nested:true
  end

  devise_for :users,only: :sessions ,path:'users' ,controllers: {
      sessions: 'users/sessions',
  }

  devise_for :admins, path: 'admins'


  resources :users do
    resource :authentication_token, only: [:update, :destroy] ,nested:true
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
