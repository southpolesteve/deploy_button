require 'sidekiq/web'

Deploy::Application.routes.draw do
  root :to => "home#index"
  get "signin" => "sessions#new", as: :signin
  get "signout" => "sessions#destroy", as: :signout
  get "/auth/:provider/callback" => "sessions#create"
  get "/deploy/:owner/:name" => "deploy#show"
  resources :apps

  mount Sidekiq::Web => '/jobs'
end
