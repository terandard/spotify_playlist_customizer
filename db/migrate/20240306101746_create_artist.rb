# frozen_string_literal: true

class CreateArtist < ActiveRecord::Migration[7.1]
  def change
    create_table :artists do |t|
      t.string :identifier, null: false
      t.string :name, null: false
      t.json :genres
      t.integer :popularity
      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
