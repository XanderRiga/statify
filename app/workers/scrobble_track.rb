require 'scrobbles/to_tracks'
require 'users/helpers/retrieve_spotify_user'

class ScrobbleTrack
  include Sidekiq::Worker

  def perform(user_id)
    last_listened_track = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: user_id).recently_played(limit: 1).first

    last_saved_track = saved_track(user_id)

    if last_listened_track.id != last_saved_track&.id
      scrobble(user_id, last_listened_track.id)
    end
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

  def scrobble(user_id, track_id)
    Scrobble.create(user_id: user_id, track_id: track_id)
  end
end
