# frozen_string_literal: true

class AddExpiresAtOnUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :expires_at, :datetime, after: :refresh_token
  end
end
