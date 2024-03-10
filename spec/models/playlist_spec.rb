# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist do
  describe 'associations' do
    subject(:instance) { build(:playlist) }

    it { expect(instance).to belong_to(:user) }
    it { expect(instance).to have_many(:playlist_tracks).dependent(:destroy) }
  end
end
