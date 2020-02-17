class CreateListens < ActiveRecord::Migration[6.0]
  def change
    create_table :hears do |t|
      t.timestamps
    end

    add_reference :hears, :user, null: false, foreign_key: true
    add_reference :hears, :track, null: false, foreign_key: true
  end
end
