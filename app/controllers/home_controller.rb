# frozen_string_literal: true
require 'users/helpers/retrieve_spotify_user'
require 'statistics/artists'

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if spotify_user
      @top_artists = Statistics::Artists.top(user_id: current_user.id).first(10)
      @recently_played = spotify_user.recently_played(limit: 10)
      render :show
    end
  rescue Users::Exceptions::UserNotFound
    render 'home/index'
  end

  def show
    @top_artists = Statistics::Artists.top(user_id: current_user.id).first(10)
    @recently_played = spotify_user.recently_played(limit: 10)

    render 'home/index' unless spotify_user
  end

  private

  def spotify_user
    @spotify_user ||= Users::Helpers::RetrieveSpotifyUser.new.call(user_id: current_user.id)
  end
end
