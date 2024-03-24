# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Track do
  describe 'associations' do
    subject(:instance) { build(:track) }

    it { expect(instance).to belong_to(:artist) }
    it { expect(instance).to have_many(:playlist_tracks).dependent(:destroy) }
    it { expect(instance).to have_many(:playlists).through(:playlist_tracks) }
  end
end
