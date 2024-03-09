# frozen_string_literal: true

class CreateTracks < ActiveRecord::Migration[7.1]
  def change
    create_table :tracks do |t|
      t.references :artist, null: false, foreign_key: true
      t.string :identifier, null: false
      t.integer :popularity, null: false
      t.integer :duration_ms, null: false
      t.string :name
      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
