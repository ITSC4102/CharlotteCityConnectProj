Rails.application.routes.draw do
  # Homepage
  root "pages#home"

  # Dashboard / personal schedule
  get "dashboard", to: "pages#dashboard"

  # Events pages
  resources :events do
    post "rsvp", on: :member   # for RSVP button
  end
end



