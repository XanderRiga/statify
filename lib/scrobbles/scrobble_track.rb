module Scrobbles
  class ScrobbleTrack
    def call(user_id:, track:)
      Scrobble.create(user_id: user_id, track_id: track.id, artist_ids: artists_ids_from_track(track))
    end

    private

    def artists_ids_from_track(track)
      track.artists.map do |artist|
        artist.id
      end
    end
  end
end
