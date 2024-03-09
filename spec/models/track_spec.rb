# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Track do
  describe 'associations' do
    subject(:instance) { build(:track) }

    it { expect(instance).to belong_to(:artist) }
  end
end
