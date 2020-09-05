# frozen_string_literal: true
require 'users/helpers/retrieve_spotify_user'
require 'statistics/artists'

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @spotify_user = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: current_user.id)

    return render 'home/index' unless @spotify_user

    @recently_played = @spotify_user.recently_played(limit: 10)
    render :show
  end

  def show
    @spotify_user = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: current_user.id)

    render 'home/index' unless @spotify_user

    recently_played_db = Hear
                             .where(user_id: current_user.id)
                             .order(created_at: :asc)
                             .last(10)

    most_played_ids = Hear.where(user_id: current_user.id).joins(:track).where.not('tracks.name' => 'Unknown Track').top(:track_id, 10)

    @most_played_tracks = []
    most_played_ids.each do |id, count|
      track = Track.find(id)
      @most_played_tracks << { name: track.name, artist: track.artists.first.name, plays: count }
    end

    if recently_played_db
      @recently_played = recently_played_db.reverse.map do |hear|
        hear.track
      end
    else
      @recently_played = @spotify_user.recently_played(limit: 10)
    end
  end
end
