Reunitedway::Application.routes.draw do

  get '/auth/:provider/callback' => 'authentications#create'
  get '/status' => 'application#status'

  get 'search/index'
  get 'static_page/index'
  get 'sessions/facebook'
  get 'sessions/twitter'
  delete 'sessions/destroy'

  match '/search', to: 'search#index', via: :get
  match '/signout', to: 'sessions#destroy', via: :delete

  get "search"            => "search#index"
  get "search/locations"  => "search#locations"

  devise_for :users

  resources :users do 
    member do
      get 'attend'
      get 'remove'
    end
  end

  root to: 'static_page#index'
end
