# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  get '/auth/spotify/callback', to: 'users#spotify'

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
end
