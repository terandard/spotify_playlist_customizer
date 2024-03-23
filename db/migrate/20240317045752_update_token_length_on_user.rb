# frozen_string_literal: true

class UpdateTokenLengthOnUser < ActiveRecord::Migration[7.1]
  def up
    change_table :users, bulk: true do |t|
      t.change :access_token, :string, limit: 512
      t.change :refresh_token, :string, limit: 512
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.change :access_token, :string, limit: 255
      t.change :refresh_token, :string, limit: 255
    end
  end
end
