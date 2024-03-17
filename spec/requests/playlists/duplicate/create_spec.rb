# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists::Duplicate' do
  describe 'POST /playlists/:identifier/duplicate' do
    subject(:api_request) { post "/playlists/#{playlist_id}/duplicate", params: { name: 'New Playlist' } }

    let(:user) { create(:user) }
    let(:playlist) { create(:playlist, user:) }
    let(:playlist_id) { playlist.identifier }
    let(:v1_api_client) do
      stub_api_client(
        Spotify::V1ApiClient,
        create_playlist: create_playlist_response,
        add_playlist_tracks: nil
      )
    end
    let(:create_playlist_response) do
      {
        id: 'new_playlist_identifier',
        name: 'New Playlist'
      }
    end

    before do
      create_list(:playlist_track, 3, playlist:)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) # rubocop:disable RSpec/AnyInstance
      allow(Spotify::V1ApiClient).to receive(:new).and_return(v1_api_client)
    end

    context 'when a normal case' do
      it 'redirects to the playlists page' do
        expect(api_request).to redirect_to(playlist_path('new_playlist_identifier'))
      end

      it 'creates a new playlist' do
        expect { api_request }
          .to change(Playlist, :count).by(1)
          .and change(PlaylistTrack, :count).by(playlist.playlist_tracks.count)
      end

      it 'requests playlist creation' do
        api_request
        expect(v1_api_client)
          .to have_received(:create_playlist)
          .with(name: 'New Playlist')
      end

      it 'requests playlist tracks addition' do
        api_request
        expect(v1_api_client)
          .to have_received(:add_playlist_tracks)
          .with(playlist_identifier: 'new_playlist_identifier', tracks: playlist.playlist_tracks.map(&:track))
      end
    end
  end
end
