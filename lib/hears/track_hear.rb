require 'hears/find_or_create_track'

module Hears
  class TrackHear
    def call(user_id:, track:)
      db_track = Hears::FindOrCreateTrack.new.call(track: track)
      Rails.logger.info("Hear being created for user: #{user_id} for track: #{db_track.id}, name: #{db_track.name}")
      Hear.create(user_id: user_id, track: db_track) if db_track
    end
  end
end
