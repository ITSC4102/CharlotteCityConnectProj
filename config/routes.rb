Rails.application.routes.draw do
  get "home/index"
  get "users/new"
  get "users/create"
  get "events/index"
  get "events/show"
  root "home#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get '/signup', to: 'users#new'
  post '/users', to: 'users#create'
  resources :events, only: [:index, :show]
  # your other routes here
end
