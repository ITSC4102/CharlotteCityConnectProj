Rails.application.routes.draw do
  get "home/index"  
  root "home#home"

  get "users/new"
  get "users/create"
  get "events/index"
  get "events/show"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'

  resources :events, only: [:index, :show]
  # route for just the current user's events
  get "my_events", to: "events#my_events", as: :my_events
end
