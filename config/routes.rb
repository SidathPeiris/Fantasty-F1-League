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
  get "my-team", to: "pages#my_team"
  get "create-team", to: "pages#create_team"
  post "create-team", to: "pages#create_team_submit"
  post "update-ratings", to: "pages#update_ratings"
          get "rating-summary", to: "pages#rating_summary"
        get "driver-calculations", to: "pages#driver_calculations"
        get "admin", to: "pages#admin_panel"
        post "update-standings", to: "pages#update_standings"
        post "check-new-results", to: "pages#check_new_results"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :drivers, only: [:index, :show]
      resources :constructors, only: [:index, :show]
      resources :teams, only: [:index, :show, :create, :update, :destroy] do
        member do
          post :submit
        end
      end
    end
  end

  # User registration
  post "users", to: "users#create"

  # Sessions (login/logout)
  post "sessions", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Reveal health check on /up
  get "up" => "rails/health#show", as: :rails_health_check
end
