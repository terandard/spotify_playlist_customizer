# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists' do
  describe 'GET /playlists/:identifier' do
    subject(:api_request) { get "/playlists/#{playlist_id}" }

    let(:user) { create(:user) }
    let(:playlist_id) { '123' }
    let(:v1_api_client) { stub_api_client(Spotify::V1ApiClient, playlist_details: { 'items' => [] }) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) # rubocop:disable RSpec/AnyInstance
      allow(Spotify::V1ApiClient).to receive(:new).and_return(v1_api_client)
    end

    it 'returns http success' do
      api_request
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    it 'requests playlist details' do
      api_request
      expect(v1_api_client).to have_received(:playlist_details)
    end
  end
end
