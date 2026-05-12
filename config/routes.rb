Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  namespace :api do
    namespace :v1 do
      get "/feed", to: "feeds#index"

      resources :posts, only: [ :create, :show ]
      resources :subscriptions, only: [ :create, :destroy ]
      resources :comments, only: [ :create ]
      resources :likes, only: [ :create ]
    end
  end
end
