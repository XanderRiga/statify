class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @spotify_user = current_spotify_user

    return render :show if @spotify_user
  end

  def show
    @spotify_user = current_spotify_user
    return render 'home/index' unless @spotify_user
  end

  private

  def current_spotify_user
    user = SpotifyUser.find_by(user_id: current_user.id)

    return nil unless user

    user_hash = user.spotify_user_hash
    RSpotify::User.new(user_hash)
  end
end
