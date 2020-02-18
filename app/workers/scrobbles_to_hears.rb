class ScrobblesToHears
  include Sidekiq::Worker

  def perform
    Scrobble.all.each do |scrobble|
      ScrobbleToHear.perform_async(scrobble.id)
    end
  end
end