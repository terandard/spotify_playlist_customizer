# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    subject(:instance) { build(:user) }

    it { expect(instance).to have_many(:playlists).dependent(:destroy) }
  end
end
