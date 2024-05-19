# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists::Tracks' do
  describe 'POST /playlists/:identifier/tracks' do
    subject(:api_request) { post "/playlists/#{playlist_id}/tracks", params: { track_identifier: } }

    let(:user) { create(:user) }
    let(:playlist) { create(:playlist, user:) }
    let(:playlist_id) { playlist.identifier }
    let(:track) { create(:track) }
    let(:track_identifier) { track.identifier }
    let(:v1_api_client) do
      stub_api_client(
        Spotify::V1ApiClient,
        add_playlist_tracks: nil
      )
    end

    before do
      create(:playlist_track, playlist:)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) # rubocop:disable RSpec/AnyInstance
      allow(Spotify::V1ApiClient).to receive(:new).and_return(v1_api_client)
    end

    context 'when a normal case' do
      it 'redirects to the playlists page' do
        expect(api_request).to redirect_to(playlist_path(playlist.identifier))
      end

      it 'adds a track to the playlist' do
        api_request
        expect(v1_api_client)
          .to have_received(:add_playlist_tracks)
          .with(playlist_identifier: playlist.identifier, tracks: [track], position: 1)
      end

      it 'saves the track to the playlist' do
        expect { api_request }
          .to change(playlist.playlist_tracks, :count).by(1)
      end

      it 'persists the track to the playlist' do
        api_request
        expect(playlist.playlist_tracks.last.track).to eq(track)
      end
    end
  end
end
