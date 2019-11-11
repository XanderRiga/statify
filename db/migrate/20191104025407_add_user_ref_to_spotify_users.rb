# frozen_string_literal: true

class AddUserRefToSpotifyUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :spotify_users, :user, null: false, foreign_key: true
  end
end
