require 'hears/track_hear'
require 'users/helpers/retrieve_spotify_user'

class TrackHear
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    last_listened_track = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: user_id).
        recently_played(limit: 1).first
    last_saved_track = saved_track(user_id)

    if last_listened_track.id != last_saved_track&.id
      Hears::TrackHear.new.call(user_id: user_id, track: last_listened_track)
    end
  rescue StandardError
    # No point in continuing if this failed, it will just fail again.
    return
  end

  private

  def saved_track(user_id)
    if Hear.where(user_id: user_id).exists?
      # Since this is a where, this is technically a list even though we only want the last one
      hear = Hear.where(user_id: user_id).order('created_at desc').limit(1).last

      return RSpotify::Track.find(Track.find(hear.track_id).id)
    end

    nil
  end
end