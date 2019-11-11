class CreateScrobbles < ActiveRecord::Migration[6.0]
  def change
    create_table :scrobbles do |t|
      t.timestamps
    end
  end
end
