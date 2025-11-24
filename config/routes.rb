Rails.application.routes.draw do
  root "home#home"

  # USERS
  get "/signup", to: "users#new"
  post "/users", to: "users#create"

  # SESSIONS
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # EVENTS
  resources :events, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  post "/events/:id/register", to: "events#register", as: :register_event
  post "/events/:id/unregister", to: "events#unregister", as: :unregister_event

  get "my_created_events", to: "events#my_created_events"

  get "my_events", to: "events#my_events"

  get "/calendar", to: "events#calendar", as: :calendar

end
