class HomeController < ApplicationController
  before_action :authenticate_user!

  def show
    user_hash = SpotifyUser.find_by(user_id: current_user.id).spotify_user_hash
    @spotify_user = RSpotify::User.new(user_hash)
  end
end
