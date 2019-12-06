# frozen_string_literal: true

require 'rspotify'
require 'users/helpers/retrieve_spotify_user'

class SpotifyController < ApplicationController
  before_action :authenticate_user!

  def artist
    @artist = RSpotify::Artist.find(params['id'])
  end

  def recommendations
    @top_artists = Users::Helpers::RetrieveSpotifyUser.
        new.
        call(user_id: current_user.id)&.
        top_artists(limit: 20, time_range: 'short_term')
  end

  def recommendation_result
    @tracks = RSpotify::Recommendations.generate(formatted_form_response).tracks
    # render 'spotify/recommendation_result'
  end

  private

  def formatted_form_response
    {
        target_acousticness: params['acousticness'],
        target_danceability: params['danceability'],
        target_energy: params['energy'],
        target_instrumentalness: params['instrumentalness'],
        target_liveness: params['liveness'],
        target_loudness: params['loudness'],
        target_popularity: params['popularity'],
        target_speechiness: params['speechiness'],
        target_valence: params['valence'],
        seed_artists: artist_list
    }
  end

  def artist_list
    artists = []
    params.each do |key, value|
      if key.include?('artist_')
        artists << value
      end
    end

    artists
  end
end
