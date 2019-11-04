class HomeController < ApplicationController
  before_action :authenticate_user!

  def show
    user = SpotifyUser.find_by(user_id: current_user.id)
    return render 'home/index' unless user

    user_hash = user.spotify_user_hash
    @spotify_user = RSpotify::User.new(user_hash)
  end
end
