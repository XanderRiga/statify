require 'hears/find_or_create_artist'
require 'hears/find_or_create_album'

module Hears
  class FindOrCreateTrack
    # This takes in an RSpotify::Track, not to be confused with the model Track
    def call(track:)
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
          album: Hears::FindOrCreateAlbum.new.call(album: track.album),
          artists: track.artists.map { |artist| Hears::FindOrCreateArtist.new.call(artist: artist) }
      )
    end
  end
end
