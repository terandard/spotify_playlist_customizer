# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists::Tracks' do
  describe 'DELETE /playlists/:identifier/tracks' do
    subject(:api_request) { delete "/playlists/#{playlist_id}/tracks", params: { track_identifier: } }

    let(:user) { create(:user) }
    let(:playlist) { create(:playlist, user:) }
    let(:playlist_id) { playlist.identifier }
    let(:playlist_track) { create(:playlist_track, playlist:) }
    let(:track_identifier) { playlist_track.track.identifier }
    let(:v1_api_client) do
      stub_api_client(
        Spotify::V1ApiClient,
        delete_playlist_tracks: nil
      )
    end

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) # rubocop:disable RSpec/AnyInstance
      allow(Spotify::V1ApiClient).to receive(:new).and_return(v1_api_client)
    end

    context 'when a normal case' do
      it 'redirects to the playlists page' do
        expect(api_request).to redirect_to(playlist_path(playlist.identifier))
      end

      it 'deletes a track from the playlist' do
        api_request
        expect(v1_api_client)
          .to have_received(:delete_playlist_tracks)
          .with(playlist_identifier: playlist.identifier, tracks: [playlist_track.track])
      end

      it 'deletes a playlist track' do
        expect { api_request }
          .to change { playlist.playlist_tracks.find_by(id: playlist_track.id) }
          .from(playlist_track).to(nil)
      end
    end
  end
end
