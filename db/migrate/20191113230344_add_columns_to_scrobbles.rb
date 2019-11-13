class AddColumnsToScrobbles < ActiveRecord::Migration[6.0]
  def change
    add_column :scrobbles, :artist_ids, :text
  end
end
