class LinkTrackToArtist < ActiveRecord::Migration[6.0]
  def change
    change_table :artists do |t|
      t.belongs_to :track
    end
  end
end
