# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_323_024_011) do
  create_table 'artists', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'identifier', null: false
    t.string 'name', null: false
    t.json 'genres'
    t.integer 'popularity'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['identifier'], name: 'index_artists_on_identifier', unique: true
  end

  create_table 'playlist_tracks', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.bigint 'playlist_id', null: false
    t.bigint 'track_id', null: false
    t.integer 'position', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[playlist_id track_id], name: 'index_playlist_tracks_on_playlist_id_and_track_id', unique: true
  end

  create_table 'playlists', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.string 'identifier', null: false
    t.string 'name'
    t.string 'image_url'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_playlists_on_user_id'
  end

  create_table 'tracks', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.bigint 'artist_id', null: false
    t.string 'identifier', null: false
    t.integer 'popularity', null: false
    t.integer 'duration_ms', null: false
    t.string 'name'
    t.string 'image_url'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['artist_id'], name: 'index_tracks_on_artist_id'
    t.index ['identifier'], name: 'index_tracks_on_identifier', unique: true
  end

  create_table 'users', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'identifier', null: false
    t.string 'access_token', limit: 512, null: false
    t.string 'refresh_token', limit: 512, null: false
    t.datetime 'expires_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['identifier'], name: 'index_users_on_identifier', unique: true
  end

  add_foreign_key 'tracks', 'artists'
end
