class AddNamesToScrobbles < ActiveRecord::Migration[6.0]
  def change
    add_column :scrobbles, :track_name, :string
    add_column :scrobbles, :artist_name, :string
  end
end
