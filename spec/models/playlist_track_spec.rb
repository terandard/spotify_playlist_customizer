# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaylistTrack do
  describe 'associations' do
    subject(:instance) { build(:playlist_track) }

    it { expect(instance).to belong_to(:playlist).inverse_of(:playlist_tracks) }
    it { expect(instance).to belong_to(:track) }
  end
end
