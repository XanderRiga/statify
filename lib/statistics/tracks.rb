module Statistics
  class Tracks
    def self.time_listened(user_id:)
      ms = Hear.where(user_id: user_id).joins(:track).sum('tracks.duration_ms')
      (ms / 1000.0 / 60.0 / 60.0).round(1)
    end

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
