# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_09_222156) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.string "name", null: false
    t.string "spotify_id", null: false
    t.text "genres"
    t.string "label"
    t.integer "popularity"
    t.string "release_date"
    t.integer "total_tracks"
    t.bigint "track_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["track_id"], name: "index_albums_on_track_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "spotify_id", null: false
    t.text "genres"
    t.integer "popularity"
    t.bigint "album_id"
    t.bigint "track_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album_id"], name: "index_artists_on_album_id"
    t.index ["track_id"], name: "index_artists_on_track_id"
  end

  create_table "hears", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "track_id", null: false
    t.bigint "user_id", null: false
    t.index ["track_id"], name: "index_hears_on_track_id"
    t.index ["user_id"], name: "index_hears_on_user_id"
  end

  create_table "scrobbles", force: :cascade do |t|
    t.string "track_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.text "artist_ids"
    t.string "track_name"
    t.string "artist_name"
    t.index ["user_id"], name: "index_scrobbles_on_user_id"
  end

  create_table "spotify_users", force: :cascade do |t|
    t.jsonb "spotify_user_hash", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_spotify_users_on_user_id"
  end

  create_table "streaming_histories", force: :cascade do |t|
    t.string "file_path", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_streaming_histories_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name", null: false
    t.string "spotify_id", null: false
    t.integer "duration_ms"
    t.boolean "explicit"
    t.string "played_at"
    t.string "popularity"
    t.string "preview_url"
    t.integer "track_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "hears", "tracks"
  add_foreign_key "hears", "users"
  add_foreign_key "scrobbles", "users"
  add_foreign_key "spotify_users", "users"
  add_foreign_key "streaming_histories", "users"
end
