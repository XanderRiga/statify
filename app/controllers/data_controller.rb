# frozen_string_literal: true

require 'rspotify'
require 'users/helpers/retrieve_spotify_user'
require 'json'

class DataController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def upload
  end

  def upload_files
    files = params.select { |key| key.match?(/^file_/) }.values
    Rails.logger.info('Attempting to upload files with params: ' + files.map(&:original_filename).join(', '))

    files.each do |file|
      JSON.parse(file.read) # Want this to raise if the files are not json parseable, we don't save the parsed output

      file_path = ENV['FILE_UPLOAD_PATH'] + Time.now.to_i.to_s + file.original_filename
      unless File.file?(file_path)
        FileUtils.mv(file.tempfile, file_path)
        steaming_history = StreamingHistory.create!(
          user_id: current_user.id,
          file_path: file_path
        )

        StreamingHistory::SaveFileJob.perform_async(steaming_history.id)
      end
    end

    render json: { success: 'success' }, status: 200
  rescue JSON::ParserError => e
    render json: { error: 'One or more files was not formatted correctly. Make sure you upload them directly as given from Spotify.' }, status: 400
  rescue StandardError => e
    render json: { error: e.message }, status: 400
  end
end
