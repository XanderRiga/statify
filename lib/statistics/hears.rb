module Statistics
  class Hears
    def self.explicit_hash(user_id:)
      sql = 'select count(*)'\
        ' from hears'\
        ' inner join tracks on hears.track_id = tracks.id'\
        " where user_id = #{user_id} and tracks.explicit = true"
      num_explicit = ActiveRecord::Base.connection.execute(sql).first['count']

      num_all_hears = Hear.where(user_id: user_id).count

      # num_explicit_hears = all_hears.select do |hear|
      #   track = Track.find(hear.track_id)
      #   track.explicit
      # end.count

      {
        'Explicit' => num_explicit,
        'Non-explicit' => num_all_hears - num_explicit
      }
    end
  end
end
