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
        top_artists(limit: 50, time_range: 'short_term')
  end
end
