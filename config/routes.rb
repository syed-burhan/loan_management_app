Rails.application.routes.draw do

  resources :home, only: :index
  resources :loans do
    member do
      patch :approve
      patch :reject
      patch :confirm
      patch :repay
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
