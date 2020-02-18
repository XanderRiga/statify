module Hears
  class TrackHear
    def call(user_id:, track:)
      db_track = find_or_create_track(track)
      Hear.create(user_id: user_id, track_id: db_track.id)
    end

    private

    def find_or_create_track(track)
      if (return_track = Track.find_by(spotify_id: track.id))
        return return_track
      end

      Track.create(
          name: track.name,
          spotify_id: track.id,
          duration_ms: track.duration_ms,
          explicit: track.explicit,
          popularity: track.popularity,
          preview_url: track.preview_url,
          track_number: track.track_number,
          album: find_or_create_album(track.album),
          artists: track.artists.map { |artist| find_or_create_artist(artist) }
      )
    end

    def find_or_create_artist(artist)
      if (return_artist = Artist.find_by(spotify_id: artist.id))
        return return_artist
      end

      Artist.create(
        name: artist.name,
        spotify_id: artist.id,
        genres: artist.genres,
        popularity: artist.popularity
      )
    end

    def find_or_create_album(album)
      if (return_album = Album.find_by(spotify_id: album.id))
        return return_album
      end

      Album.create(
        name: album.name,
        spotify_id: album.id,
        genres: album.genres,
        popularity: album.popularity,
        release_date: album.release_date,
        total_tracks: album.total_tracks,
        artists: album.artists.map { |artist| find_or_create_artist(artist) }
      )
    end
  end
end
