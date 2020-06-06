# frozen_string_literal: true
require 'users/helpers/retrieve_spotify_user'
require 'statistics/artists'

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @spotify_user = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: current_user.id)

    if @spotify_user
      @recently_played = @spotify_user.recently_played(limit: 10)
      render :show
    end
  rescue Users::Exceptions::UserNotFound
    render 'home/index'
  end

  def show
    @spotify_user = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: current_user.id)

    recently_played_db = Hear
                             .where(user_id: current_user.id)
                             .order(created_at: :asc)
                             .last(10)

    if recently_played_db
      @recently_played = recently_played_db.reverse.map do |hear|
        hear.track
      end
    else
      @recently_played = @spotify_user.recently_played(limit: 10)
    end

    render 'home/index' unless @spotify_user
  end
end
