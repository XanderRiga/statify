class CreateArtist < ActiveRecord::Migration[6.0]
  def change
    create_table :hears do |t|
      t.timestamps
    end

    add_reference :hears, :user, null: false, foreign_key: true

    create_table :tracks do |t|
      t.string :name, null: false
      t.string :spotify_id, null: false
      t.integer :duration_ms
      t.boolean :explicit
      t.string :played_at
      t.string :popularity
      t.string :preview_url
      t.integer :track_number
      t.belongs_to :hear

      t.timestamps
    end

    create_table :albums do |t|
      t.string :name, null: false
      t.string :spotify_id, null: false
      t.text :genres
      t.string :label
      t.integer :popularity
      t.string :release_date
      t.integer :total_tracks
      t.belongs_to :track

      t.timestamps
    end

    create_table :artists do |t|
      t.string :name, null: false
      t.string :spotify_id, null: false
      t.text :genres
      t.integer :popularity
      t.belongs_to :album
      t.belongs_to :track

      t.timestamps
    end
  end
end

# some bullshit code
# class CreateListens < ActiveRecord::Migration[6.0]
#   def change
#
#
#     add_reference :hears, :user, null: false, foreign_key: true
#     add_reference :hears, :track, null: false, foreign_key: true
#   end
# end
