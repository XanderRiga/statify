# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  get '/auth/spotify/callback', to: 'users#spotify'

  resources :users
  resources :home, only: [:index, :show]
  get 'landing_page', to: 'home#show'
end
