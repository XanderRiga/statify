module Statistics
  class Tracks
    def self.top(user_id:, start_date: Time.parse('2006-04-23'), end_date: Time.now)
      scrobbles = Scrobble.in_date_range(start_date, end_date).where(user_id: user_id)

      scrobbles.each_with_object(Hash.new({})) do |scrobble, hash|
        if valid_track(scrobble.track_name)
          if hash[scrobble.track_name] == {}
            hash[scrobble.track_name] = {
                'occurrences' => 0,
                'id' => scrobble.track_id,
                'artist' => scrobble.artist_name,
                'artist_id' => scrobble.artist_ids.first
            }
          end
          hash[scrobble.track_name]['occurrences'] += 1
        end
      end.sort_by{ |k,v| v['occurrences'] }.reverse!
    end

    def self.valid_track(track_name)
      track_name && track_name != 'Unknown Track'
    end
  end
end
