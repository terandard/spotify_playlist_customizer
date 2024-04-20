# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists' do
  describe 'GET /playlists/:identifier' do
    subject(:api_request) { get "/playlists/#{playlist_id}" }

    let(:user) { create(:user) }
    let(:playlist) { create(:playlist, user:) }
    let(:playlist_id) { playlist.identifier }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) # rubocop:disable RSpec/AnyInstance
    end

    it 'returns http success' do
      api_request
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    context 'when the playlist does not exist' do
      let(:playlist_id) { 'invalid' }

      it 'returns http not found' do
        api_request
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
