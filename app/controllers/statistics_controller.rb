require 'statistics/artists'
require 'statistics/tracks'

class StatisticsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def overview
  end

  def overview_data
    return render json: {}, status: 400 if params['start_date'].empty? || params['end_date'].empty?

    render json: { start_date: params['start_date'], end_date: params['end_date'] }
  end

  def artists
  end

  def top_artists
    return render json: {}, status: 400 if params['start_date'].empty? || params['end_date'].empty?
    top_artists = Statistics::Artists.top(user_id: current_user.id, start_date: params['start_date'], end_date: params['end_date'])

    render json: top_artists.first(10), status: 200
  end

  def tracks
  end

  def top_tracks
    return render json: {}, status: 400 if params['start_date'].empty? || params['end_date'].empty?
    top_artists = Statistics::Tracks.top(user_id: current_user.id, start_date: params['start_date'], end_date: params['end_date'])

    render json: top_artists.first(10), status: 200
  end
end