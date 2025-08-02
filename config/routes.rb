Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Landing page as root
  root "pages#home"
  
  # Additional pages
  get "about", to: "pages#about"
  get "features", to: "pages#features"
  get "contact", to: "pages#contact"
  get "signup", to: "pages#signup"
  get "login", to: "pages#login"
  get "dashboard", to: "pages#dashboard"

  # User registration
  post "users", to: "users#create"

  # Sessions (login/logout)
  post "sessions", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Reveal health check on /up
  get "up" => "rails/health#show", as: :rails_health_check
end
