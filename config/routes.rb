Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'admin/dashboard#index'
  
  get "up" => "rails/health#show", as: :rails_health_check
  post '/auth/login',to:"authentication#login"

  resources :users
end
