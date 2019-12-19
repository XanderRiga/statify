# frozen_string_literal: true

require 'rspotify'

class UsersController < ApplicationController
  def spotify
    if user_signed_in?
      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

      if SpotifyUser.exists?(user_id: current_user.id)
        spotify_user = SpotifyUser.find_by(user_id: current_user.id)
        spotify_user.update(
          spotify_user_hash: @spotify_user.to_hash
        )
      else
        SpotifyUser.create(
          user_id: current_user.id,
          spotify_user_hash: @spotify_user.to_hash
        )
      end

      redirect_to landing_page_path
    else
      render 'home/index'
    end
  end

  def show
    render 'home/index'
  end
end
