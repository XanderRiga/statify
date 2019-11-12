class ScrobbleUsers
  include Sidekiq::Worker

  def perform
    User.all.each do |user|
      ScrobbleTracks.perform_async(user.id)
    end
  end
end