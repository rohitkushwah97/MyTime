Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'admin/dashboard#index'
  
  get "up" => "rails/health#show", as: :rails_health_check
  post '/auth/login',to:"authentication#login"

  # forget_password controller routes for send_otp, verify_otp and reset_password
  post '/forget_passwords/send_otp',to:"forget_passwords#send_otp"
  post '/forget_passwords/verify_otp',to:"forget_passwords#verify_otp"
  put '/forget_passwords/forget_password',to:"forget_passwords#forget_password"

  # reset_password controller routes for create api
  post '/reset_password', to:"reset_password#create"

  resources :users
  resources :categories, only: [:index]
  resources :posts do
    collection do
      get :current_user_posts
    end
  end

  resources :my_phone_books, only: [:create]
end
