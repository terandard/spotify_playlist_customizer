# frozen_string_literal: true

class CreatePlaylistTrack < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_tracks do |t|
      t.references :playlist, null: false, index: false
      t.references :track, null: false, index: false
      t.integer :position, null: false, default: 0

      t.timestamps

      t.index %i[playlist_id track_id], unique: true
    end
  end
end
