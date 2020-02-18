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
end