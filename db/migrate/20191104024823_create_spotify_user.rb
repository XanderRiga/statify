class CreateSpotifyUser < ActiveRecord::Migration[6.0]
  def change
    create_table :spotify_users do |t|
      t.jsonb :spotify_user_hash
    end
  end
end
