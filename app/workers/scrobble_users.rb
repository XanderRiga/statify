class ScrobbleUsers
  include Sidekiq::Worker

  def perform
    User.all.each do |user|
      ScrobbleTrack.perform_async(user.id)
    end
  end
end