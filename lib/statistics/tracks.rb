module Statistics
  class Tracks
    def self.top(user_id:, start_date: Time.parse('2006-04-23'), end_date: Time.now)
      Hear.where(user_id: user_id)
          .in_date_range(start_date, end_date)
          .joins(:track)
          .group('tracks.name')
          .order(count_all: :desc)
          .limit(10)
          .count
    end

    def self.valid_track(track_name)
      track_name && track_name != 'Unknown Track'
    end
  end
end
