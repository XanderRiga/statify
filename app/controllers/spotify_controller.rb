require 'rspotify'

class SpotifyController < ApplicationController
  before_action :authenticate_user!

  def artist
    @artist = RSpotify::Artist.find(params['id'])
  end
end