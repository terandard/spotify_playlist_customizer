# frozen_string_literal: true

class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :identifier, null: false
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
