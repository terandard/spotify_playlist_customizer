# frozen_string_literal: true

FactoryBot.define do
  factory :playlist_track do
    playlist
    track
  end
end
