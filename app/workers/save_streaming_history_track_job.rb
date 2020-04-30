require 'rspotify'
require 'hears/find_or_create_track'

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

    rspotify_track = RSpotify::Track.search(listen['trackName'] + ' ' + listen['artistName']).first

    unless rspotify_track
      return
    end

    db_track = Hears::FindOrCreateTrack.new.call(track: rspotify_track)

    Hear.create(
        user_id: user_id,
        track: db_track,
        created_at: listen['endTime'],
        updated_at: listen['endTime']
    ) if db_track
  end
end
