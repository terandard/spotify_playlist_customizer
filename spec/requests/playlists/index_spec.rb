# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists' do
  describe 'GET /playlists' do
    subject(:api_request) { get '/playlists' }

    let(:user) { create(:user) }
    let(:v1_api_client) { stub_api_client(Spotify::V1ApiClient, my_playlists: playlist_response) }
    let(:playlist_response) do
      {
        items: [
          {
            id: 'playlist_identifier',
            name: 'playlist_name',
            images: [{ url: 'https://example.png' }],
            tracks: { total: 1 },
            owner: { id: 'user_identifier', display_name: 'user_name' }
          }
        ]
      }
    end

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) # rubocop:disable RSpec/AnyInstance
      allow(Spotify::V1ApiClient).to receive(:new).and_return(v1_api_client)
    end

    it 'returns http success' do
      api_request
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'requests user playlists' do
      api_request
      expect(v1_api_client).to have_received(:my_playlists)
    end

    it 'saves user playlists' do
      expect { api_request }.to change(user.playlists, :count).by(1)
    end

    it 'saves playlist details' do
      api_request
      expect(user.playlists.last).to have_attributes(
        identifier: 'playlist_identifier',
        name: 'playlist_name',
        image_url: 'https://example.png'
      )
    end
  end
end
