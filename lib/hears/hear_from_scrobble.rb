require 'hears/find_or_create_track'

module Hears
  class HearFromScrobble
    def call(scrobble:)
      track = Hears::FindOrCreateTrack.new.call(track: RSpotify::Track.find(scrobble.track_id))
      Hear.create(
        user_id: scrobble.user_id,
        track: track,
        created_at: scrobble.created_at,
        updated_at: scrobble.updated_at
      ) if track
    end
  end
end
