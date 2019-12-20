# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  root 'home#index'
  get '/auth/spotify/callback', to: 'users#spotify'

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :users
  resources :home, only: %i[index show]
  get 'landing_page', to: 'home#show'

  resources :spotify do
    member do
      get 'artist'
    end

    collection do
      get 'recommendations'
      post 'recommendation_result'
      post 'save_playlist'
    end
  end

  resources :data do
    collection do
      get 'upload'
      post 'upload'
      post 'upload_files'
    end
  end

  resources :statistics do
    collection do
      get 'artists'
      post 'top_artists'
    end
  end
end
