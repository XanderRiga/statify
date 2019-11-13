module Scrobbles
  class ToTracks
    def call(scrobbles:)
      track_ids = scrobbles.map do |scrobble|
        scrobble.track_id
      end
      RSpotify::Track.find(track_ids)
    end
  end
end
