require 'statistics/artists'

class StatisticsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def artists
  end

  def top_artists
    return render json: {}, status: 400 if params['start_date'].empty? || params['end_date'].empty?
    top_artists = Statistics::Artists.top(user_id: current_user.id, start_date: params['start_date'], end_date: params['end_date'])

    render json: top_artists.first(10), status: 200
  end
end