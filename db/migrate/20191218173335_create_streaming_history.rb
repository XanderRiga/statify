class CreateStreamingHistory < ActiveRecord::Migration[6.0]
  def change
    create_table :streaming_histories do |t|
      t.string :file_path, null: false
    end
    add_reference :streaming_histories, :user, null: false, foreign_key: true
  end
end
