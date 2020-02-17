class LinkTracksToHears < ActiveRecord::Migration[6.0]
  def change
    change_table :tracks do |t|
      t.belongs_to :hears
    end
  end
end
