# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Artist do
  describe 'associations' do
    subject(:instance) { build(:artist) }

    it { expect(instance).to have_many(:tracks).dependent(:destroy) }
  end
end
