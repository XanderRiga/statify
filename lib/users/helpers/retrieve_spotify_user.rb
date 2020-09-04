require 'users/exceptions/user_not_found'

module Users
  module Helpers
    class RetrieveSpotifyUser
      def call(user_id:)
        spotify_user = SpotifyUser.find_by(user_id: user_id)

        return nil unless spotify_user

        user_hash = spotify_user.spotify_user_hash
        RSpotify::User.new(user_hash)
      end
    end
  end
end
