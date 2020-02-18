require 'hears/find_or_create_track'

module Hears
  class TrackHear
    def call(user_id:, track:)
      db_track = Hears::FindOrCreateTrack.new.call(track: track)
      Hear.create(user_id: user_id, track_id: db_track.id)
    end
  end
end
