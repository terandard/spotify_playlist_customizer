# frozen_string_literal: true

# == Schema Information
#
# Table name: tracks
#
#  id          :bigint           not null, primary key
#  artist_id   :bigint           not null
#  identifier  :string(255)      not null
#  popularity  :integer          not null
#  duration_ms :integer          not null
#  name        :string(255)
#  image_url   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tracks_on_artist_id   (artist_id)
#  index_tracks_on_identifier  (identifier) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => artists.id)
#
class Track < ApplicationRecord
  belongs_to :artist
  has_many :playlist_tracks, dependent: :destroy
end
