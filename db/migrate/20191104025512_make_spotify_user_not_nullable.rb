class MakeSpotifyUserNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:spotify_users, :spotify_user_hash, false )
  end
end
