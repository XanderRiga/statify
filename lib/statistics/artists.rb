module Statistics
  class Artists
    def self.top(user_id:, start_date: Time.parse('2006-04-23'), end_date: Time.now)
      Hear.where(user_id: user_id)
          .in_date_range(start_date, end_date)
          .joins(track: [:artists])
          .group('artists.name')
          .order(count_all: :desc)
          .limit(10)
          .count
    end

    def self.valid_artist(artist_name)
      artist_name && artist_name != 'Unknown Artist' && artist_name != ''
    end

    def self.top_6_months(user_id:)
      start_date = Time.now.beginning_of_month
      end_date = Time.now

      top_artists = []
      6.times do
        top_artists << self.top(
            user_id: user_id,
            start_date: start_date,
            end_date: end_date
        ).slice(0, 5)

        start_date = start_date.last_month
        end_date = start_date.end_of_month
      end

      top_artists
    end
  end
end
