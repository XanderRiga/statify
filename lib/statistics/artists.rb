module Statistics
  class Artists
    def self.top(user_id:, start_date: Time.parse('2006-04-23'), end_date: Time.now)
      scrobbles = Scrobble.in_date_range(start_date, end_date).where(user_id: user_id)

      scrobbles.each_with_object(Hash.new({})) do |scrobble, hash|
        if valid_artist(scrobble.artist_name)
          if hash[scrobble.artist_name] == {}
            hash[scrobble.artist_name] = {
                'occurrences' => 0,
                'id' => scrobble.artist_ids.first
            }
          end
          hash[scrobble.artist_name]['occurrences'] += 1
        end
      end.sort_by{ |k,v| v['occurrences'] }.reverse!
    end

    def self.valid_artist(artist_name)
      artist_name && artist_name != 'Unknown Artist'
    end
  end
end
