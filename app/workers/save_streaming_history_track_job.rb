require 'rspotify'

class SaveStreamingHistoryTrackJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options retry: 20

  sidekiq_throttle({ :threshold => { :limit => 1, :period => 1 } }) # 1 job per second max

  sidekiq_retry_in do |count, exception|
    1.hour.to_i * count
  end

  def perform(json_listen, user_id)
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
