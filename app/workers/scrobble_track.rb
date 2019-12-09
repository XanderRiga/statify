require 'scrobbles/to_tracks'
require 'scrobbles/scrobble_track'
require 'users/helpers/retrieve_spotify_user'
require 'users/exceptions/user_not_found'

class ScrobbleTrack
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    last_listened_track = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: user_id).recently_played(limit: 1).first

    last_saved_track = saved_track(user_id)

    if last_listened_track.id != last_saved_track&.id
      Scrobbles::ScrobbleTrack.new.call(user_id: user_id, track: last_listened_track)
    end
  rescue Users::Exceptions::UserNotFound, StandardError
    # If we don't have a user, don't keep trying
    return
  end

  private

  def saved_track(user_id)
    if Scrobble.where(user_id: user_id).exists?
      # Since this is a where, this is technically a list even though we only want the last one
      scrobbles = Scrobble.where(user_id: user_id).order('created_at desc').limit(1)

      return Scrobbles::ToTracks.new.call(scrobbles: scrobbles).first
    end

    nil
  end
end
