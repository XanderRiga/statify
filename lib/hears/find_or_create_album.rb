require 'hears/find_or_create_artist'

module Hears
  class FindOrCreateAlbum
    def call(album:)
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
          artists: album.artists.map { |artist| Hears::FindOrCreateArtist.new.call(artist: artist) }
      )
    end
  end
end
