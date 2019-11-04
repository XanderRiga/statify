# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  get 'home/index'
  get '/auth/spotify/callback', to: 'users#spotify'

  resources :users
end
