require 'sidekiq/web'

Deploy::Application.routes.draw do
  root :to => "home#index"
  get "signin" => "sessions#new", as: :signin
  get "signout" => "sessions#destroy", as: :signout
  get "/auth/:provider/callback" => "sessions#create"
  get "/deploy/:owner/:name" => "deploy#new", as: :deploy

  resources :apps, only: [:show, :create] do 
    member do
      post :charge
    end
  end

  mount Sidekiq::Web => '/jobs'
end
