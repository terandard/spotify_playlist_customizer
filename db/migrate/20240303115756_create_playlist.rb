# frozen_string_literal: true

class CreatePlaylist < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.references :user, null: false
      t.string :identifier, null: false
      t.string :name
      t.string :image_url
      t.timestamps
    end
  end
end
