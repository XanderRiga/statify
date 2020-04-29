module Statistics
  class Hears
    def self.explicit_hash(user_id:)
      num_explicit = Hear.where(user_id: user_id, track: Track.where(explicit: true)).count

      {
        'Explicit' => num_explicit,
        'Non-explicit' => num_all_hears(user_id: user_id) - num_explicit
      }
    end

    def self.popular_listens_hash(user_id:)
      num_most_popular = popularity_count(user_id: user_id, lower_bound: 75, upper_bound: 101)
      num_somewhat_popular = popularity_count(user_id: user_id, lower_bound: 50, upper_bound: 75)
      num_less_popular = popularity_count(user_id: user_id, lower_bound: 25, upper_bound: 50)
      num_unpopular = popularity_count(user_id: user_id, lower_bound: 0, upper_bound: 25)

      {
        'Most Popular(75-100)' => num_most_popular,
        'Somewhat Popular(50-74)' => num_somewhat_popular,
        'Less Popular(25-49)' => num_less_popular,
        'Unopular(0-24)' => num_unpopular
      }
    end

    def self.popularity_count(user_id:, lower_bound:, upper_bound:)
      Hear.joins(:track).where(user_id: user_id).where("cast(tracks.popularity as int) < #{upper_bound} and cast(tracks.popularity as int) >= #{lower_bound}").count
    end

    def self.num_all_hears(user_id:)
      Hear.where(user_id: user_id).count
    end
  end
end
