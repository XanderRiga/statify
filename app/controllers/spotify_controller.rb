require 'rspotify'

class SpotifyController < ApplicationController
  before_action :authenticate_user!

  def artist
    @artist = RSpotify::Artist.find(params['id'])
  end

  def recommendations
    @top_artists = current_spotify_user&.top_artists(limit: 50, time_range: 'short_term')
  end

  private

  def current_spotify_user
    user = SpotifyUser.find_by(user_id: current_user.id)

    return nil unless user

    user_hash = user.spotify_user_hash
    RSpotify::User.new(user_hash)
  end
end