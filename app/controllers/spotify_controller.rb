# frozen_string_literal: true

require 'rspotify'
require 'users/helpers/retrieve_spotify_user'

class SpotifyController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def artist
    @artist = RSpotify::Artist.find(params['id'])
  end

  def recommendations
    @top_artists = Users::Helpers::RetrieveSpotifyUser.
        new.
        call(user_id: current_user.id)&.
        top_artists(limit: 15, time_range: 'short_term')
  end

  def recommendation_result
    require 'pry'
    binding.pry
    render json: formatted_recommended_tracks(RSpotify::Recommendations.generate(formatted_form_response).tracks)
  end

  def save_playlist
    user = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: current_user.id)

    playlist = user.create_playlist!(params['playlist_name'] != '' ? params['playlist_name'] : 'statify-playlist')

    tracks = RSpotify::Track.find(params['tracks'])
    playlist.add_tracks!(tracks)

    render json: { success: true }
  end

  private

  def formatted_recommended_tracks(tracks)
    response = []
    tracks.each do |track|
      response << {
          name: track.name,
          artists: track.artists.map(&:name),
          album: track.album.name,
          id: track.id
      }
    end
    response
  end

  def formatted_form_response
    {
        target_acousticness: params['acousticness'],
        target_danceability: params['danceability'],
        target_energy: params['energy'],
        target_instrumentalness: params['instrumentalness'],
        target_liveness: params['liveness'],
        target_loudness: params['loudness'],
        target_popularity: params['popularity'],
        target_valence: params['valence'],
        seed_artists: artist_list
    }
  end

  def artist_list
    artists = []
    params.each do |key, value|
      if key.include?('input_artist_')
        searched_artist = RSpotify::Artist.search(value).first
        next unless searched_artist
        artists << searched_artist.id
      elsif key.include?('artist_')
        artists << value
      end
    end

    artists
  end
end
