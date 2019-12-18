require 'rspotify'

class SaveStreamingHistoryTrack
  include Sidekiq::Worker

  def perform(json_listen, user_id)
    require 'pry'
    binding.pry
    listen = JSON.parse(json_listen)

    track = RSpotify::Track.search(listen['trackName'] + ' ' + listen['artistName']).first
    Scrobble.create(
      track_id: track.id,
      created_at: listen['endTime'],
      user_id: user_id,
      updated_at: listen['endTime'],
      artist_ids: track.artists.map(&:id),
      track_name: listen['trackName'],
      artist_name: listen['artistName']
    ) if track
  end
end
