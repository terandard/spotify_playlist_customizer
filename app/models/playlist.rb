# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  identifier :string(255)      not null
#  name       :string(255)
#  image_url  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_playlists_on_user_id  (user_id)
#
class Playlist < ApplicationRecord
  belongs_to :user

  has_many :playlist_tracks, -> { order(:position) }, dependent: :destroy, inverse_of: :playlist
  has_many :tracks, through: :playlist_tracks
end
