# frozen_string_literal: true

class AddImageUrlOnTrack < ActiveRecord::Migration[7.1]
  def change
    add_column :tracks, :image_url, :string, after: :name
  end
end
