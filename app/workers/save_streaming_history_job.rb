require 'json'
require 'rspotify'

class SaveStreamingHistoryJob
  include Sidekiq::Worker

  def perform(streaming_history_id)
    streaming_history = StreamingHistory.find(streaming_history_id)
    file = File.open(streaming_history.file_path)
    json_data = JSON.parse(file.read)

    json_data.each do |data_point|
      unless Hear.find_by(
          track: Track.joins(:artists)
                     .where(name: data_point['trackName'])
                     .where('artists.name like :name', { name: "%#{data_point['artistName']}%" }),
          created_at: data_point['endTime']
      )
        SaveStreamingHistoryTrackJob.perform_async(data_point.to_json, streaming_history.user_id)
      end
    end

    cleanup_file(streaming_history_id)
  rescue JSON::ParserError
    # If it blows up we don't want it to retry since we will delete the file
    cleanup_file(streaming_history_id)
  rescue ActiveRecord::RecordNotFound
    # If the record doesn't exist there is nothing we can do here, don't bother retrying
    cleanup_file(streaming_history_id)
  end

  private

  def cleanup_file(streaming_history_id)
    streaming_history = StreamingHistory.find(streaming_history_id)
    File.delete(streaming_history.file_path)
    streaming_history.destroy!
  end
end