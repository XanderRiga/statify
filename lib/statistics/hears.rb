module Statistics
  class Hears
    def self.explicit_hash(user_id:)
      sql = 'select count(*)'\
        ' from hears'\
        ' inner join tracks on hears.track_id = tracks.id'\
        " where user_id = #{user_id} and tracks.explicit = true"
      num_explicit = ActiveRecord::Base.connection.execute(sql).first['count']

      {
        'Explicit' => num_explicit,
        'Non-explicit' => num_all_hears(user_id: user_id) - num_explicit
      }
    end

    def self.popular_listens_hash(user_id:)
      num_most_popular = popularity_count(user_id: user_id, lower_bound: 75, upper_bound: 100)
      num_somewhat_popular = popularity_count(user_id: user_id, lower_bound: 50, upper_bound: 75)
      num_less_popular = popularity_count(user_id: user_id, lower_bound: 25, upper_bound: 50)
      num_unpopular = popularity_count(user_id: user_id, lower_bound: 0, upper_bound: 25)

      {
        'Most Popular(75-100)' => num_most_popular,
        'Somewhat Popular(50-75)' => num_somewhat_popular,
        'Less Popular(25-50)' => num_less_popular,
        'Unopular(0-25)' => num_unpopular
      }
    end

    def self.popularity_count(user_id:, lower_bound:, upper_bound:)
        sql = 'select count(*)'\
        ' from hears'\
        ' inner join tracks on hears.track_id = tracks.id'\
        " where user_id = #{user_id} and cast(tracks.popularity as int) < #{upper_bound} and cast(tracks.popularity as int) > #{lower_bound}"
      ActiveRecord::Base.connection.execute(sql).first['count']
    end

    def self.num_all_hears(user_id:)
      Hear.where(user_id: user_id).count
    end
  end
end
