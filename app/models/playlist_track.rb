# frozen_string_literal: true

# == Schema Information
#
# Table name: playlist_tracks
#
#  id          :bigint           not null, primary key
#  playlist_id :bigint           not null
#  track_id    :bigint           not null
#  position    :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_playlist_tracks_on_playlist_id_and_track_id  (playlist_id,track_id) UNIQUE
#
class PlaylistTrack < ApplicationRecord
  belongs_to :playlist
  belongs_to :track
end
