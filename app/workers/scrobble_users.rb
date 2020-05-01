class ScrobbleUsers
  include Sidekiq::Worker

  def perform
    User.all.each do |user|
      TrackHear.perform_async(user.id)
    end
  end
end
