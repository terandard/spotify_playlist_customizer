# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists' do
  describe 'GET /playlists/:identifier/recommendations' do
    subject(:api_request) { get "/playlists/#{playlist_id}/recommendations" }

    let(:user) { create(:user) }
    let(:playlist) { create(:playlist, user:) }
    let(:playlist_id) { playlist.identifier }
    let(:v1_api_client) { stub_api_client(Spotify::V1ApiClient, recommendations: recommendations_response) }

    let(:recommendations_response) do
      {
        tracks: [
          {
            id: 'track_identifier_1',
            name: 'Track 1',
            popularity: 100,
            duration_ms: 100_000,
            album: {
              images: [
                { url: 'http://example.com/image.jpg' }
              ]
            },
            artists: [
              {
                id: 'artist_identifier_1',
                name: 'Artist 1',
                genres: %w[pop rock],
                popularity: 100
              }
            ]
          }
        ]
      }
    end

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) # rubocop:disable RSpec/AnyInstance
      allow(Spotify::V1ApiClient).to receive(:new).and_return(v1_api_client)

      create_list(:playlist_track, 2, playlist:)
    end

    it 'returns http success' do
      api_request
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:recommendations)
    end

    it 'requests recommendations' do
      api_request
      expect(v1_api_client).to have_received(:recommendations)
    end

    it 'saves recommendations' do
      expect { api_request }
        .to change(Track, :count).by(1)
        .and change(Artist, :count).by(1)
    end

    it 'persists artist' do
      api_request
      artist = Artist.find_by(identifier: 'artist_identifier_1')
      expect(artist).to have_attributes(
        name: 'Artist 1',
        genres: %w[pop rock],
        popularity: 100
      )
    end

    it 'persists track' do
      api_request
      track = Track.find_by(identifier: 'track_identifier_1')
      expect(track).to have_attributes(
        artist: Artist.find_by(identifier: 'artist_identifier_1'),
        name: 'Track 1',
        popularity: 100,
        duration_ms: 100_000,
        image_url: 'http://example.com/image.jpg'
      )
    end
  end
end
