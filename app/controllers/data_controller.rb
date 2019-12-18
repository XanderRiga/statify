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

    files.each do |file|
      JSON.parse(file.read) # Want this to raise if the files are not json parseable, we don't save the parsed output

      file_path = ENV['FILE_UPLOAD_PATH'] + file.original_filename
      unless File.file?(file_path)
        FileUtils.mv(file.tempfile, file_path)
        steaming_history = StreamingHistory.create!(
            user_id: current_user.id,
            file_path: file_path
        )

        SaveStreamingHistory.perform_async(steaming_history.id)
      end
    end

    render json: { success: 'success' }, status: 200
  rescue JSON::ParserError
    render json: { error: 'One or more of the files could not be read.' }, status: 400
  end
end
