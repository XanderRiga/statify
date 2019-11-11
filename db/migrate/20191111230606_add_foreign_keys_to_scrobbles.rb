class AddForeignKeysToScrobbles < ActiveRecord::Migration[6.0]
  def change
    add_reference :scrobbles, :user, null: false, foreign_key: true
  end
end
