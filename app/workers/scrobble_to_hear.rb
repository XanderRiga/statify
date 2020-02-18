require 'hears/hear_from_scrobble'

class ScrobbleToHear
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options retry: 20

  sidekiq_throttle({ :threshold => { :limit => 1, :period => 1 } }) # 1 job per second max

  sidekiq_retry_in do |count, exception|
    1.hour.to_i * count
  end

  def perform(scrobble_id)
    Hears::HearFromScrobble.new.call(scrobble: Scrobble.find(scrobble_id))
  end
end