# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'

  get '/auth/spotify/callback', to: 'users#spotify'

  root 'home#index'
end
