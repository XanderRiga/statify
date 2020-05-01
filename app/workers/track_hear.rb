require 'hears/track_hear'
require 'users/helpers/retrieve_spotify_user'

class TrackHear
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    last_listened_track = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: user_id).
        recently_played(limit: 1).first
    Rails.logger.info("User #{user_id} last listened to #{last_listened_track.name}")

    last_saved_track = saved_track(user_id)

    if last_listened_track.id != last_saved_track&.id
      Rails.logger.info("Last listened and saved are different, trying to save #{last_listened_track.name} for user: #{user_id}")
      Hears::TrackHear.new.call(user_id: user_id, track: last_listened_track)
    end
  rescue StandardError => e
    # No point in continuing if this failed, it will just fail again.
    Rails.logger.info("Error when saving track for user: #{user_id}. Error: #{e}")
    return
  end

  private

  def saved_track(user_id)
    Rails.logger.info("Checking for last saved track for user: #{user_id}")
    if Hear.find_by(user_id: user_id)
      Rails.logger.info("User #{user_id} has at least one hear")

      # Since this is a where, this is technically a list even though we only want the last one
      hear = Hear.where(user_id: user_id).order('created_at desc').limit(1).last

      Rails.logger.info("The last hear from user: #{user_id} is: #{hear.id} with spotify id: #{hear.track.spotify_id}")

      return RSpotify::Track.find(hear.track.spotify_id)
    end

    Rails.logger.info("No last saved track found for user: #{user_id}")
    nil
  end
end
