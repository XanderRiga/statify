class CreateScrobbles < ActiveRecord::Migration[6.0]
  def change
    create_table :scrobbles do |t|
      t.string :track_id, null: false

      t.timestamps
    end
  end
end
