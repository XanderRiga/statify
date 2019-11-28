# frozen_string_literal: true

require 'users/helpers/retrieve_spotify_user'

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @spotify_user = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: current_user.id)

    render :show if @spotify_user
  rescue Users::Exceptions::UserNotFound
    render 'home/index'
  end

  def show
    @spotify_user = Users::Helpers::RetrieveSpotifyUser.new.call(user_id: current_user.id)
    render 'home/index' unless @spotify_user
  end
end
