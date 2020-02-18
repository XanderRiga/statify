module Hears
  class FindOrCreateArtist
    def call(artist:)
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
  end
end
