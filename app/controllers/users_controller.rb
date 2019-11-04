require 'rspotify'

class UsersController < ApplicationController
  def spotify
    if user_signed_in?
      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

      SpotifyUser.create(
        user_id: current_user.id,
        spotify_user_hash: @spotify_user.to_hash
      )

      redirect_to landing_page_path
    else
      render 'home/index'
    end
  end
end
