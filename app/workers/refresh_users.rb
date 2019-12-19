require 'rspotify'

class RefreshUsers
  include Sidekiq::Worker

  def perform
    SpotifyUser.all.each do |user|
      id = user.spotify_user_hash['id']

      user.update!(spotify_user_hash: RSpotify::User.find(id).to_hash)
    end
  end
end