# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists' do
  describe 'POST /playlists/:identifier/sync' do
    subject(:api_request) { post "/playlists/#{playlist_id}/sync" }

    let(:user) { create(:user) }
    let(:playlist) { create(:playlist, user:) }
    let(:playlist_id) { playlist.identifier }
    let(:v1_api_client) { stub_api_client(Spotify::V1ApiClient, playlist_details: playlist_details_response) }
    let(:playlist_details_response) do
      {
        items: [
          {
            track: {
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
          }
        ]
      }
    end

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) # rubocop:disable RSpec/AnyInstance
      allow(Spotify::V1ApiClient).to receive(:new).and_return(v1_api_client)
    end

    it 'redirect to playlist details' do
      api_request
      expect(response).to redirect_to(playlist_path(playlist.identifier))
    end

    it 'requests playlist details' do
      api_request
      expect(v1_api_client).to have_received(:playlist_details)
    end

    it 'saves playlist details' do
      expect { api_request }
        .to change(PlaylistTrack, :count).by(1)
        .and change(Track, :count).by(1)
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

    it 'persists playlist track' do
      api_request
      playlist_track = PlaylistTrack.last
      expect(playlist_track).to have_attributes(
        playlist_id: playlist.id,
        track_id: Track.find_by(identifier: 'track_identifier_1').id,
        position: 0
      )
    end

    context 'when the api response has next field' do
      def stub_as_resource(params)
        case params
        when Hash  then Sawyer::Resource.new(agent, params)
        when Array then params.map { |hash| stub_as_resource(hash) }
        when nil   then nil
        else params
        end
      end

      def agent
        instance_double(Sawyer::Agent).tap do |agent|
          allow(agent).to receive(:parse_links) do |data|
            data ||= {}
            links = data.delete(:_links)
            [data, links]
          end
        end
      end

      before do
        next_response = {
          next: 'http://example.com/next',
          items: [
            {
              track: {
                id: 'track_identifier_2',
                name: 'Track 2',
                popularity: 100,
                duration_ms: 100_000,
                album: {
                  images: [
                    { url: 'http://example.com/image.jpg' }
                  ]
                },
                artists: [
                  {
                    id: 'artist_identifier_2',
                    name: 'Artist 2',
                    genres: %w[pop rock],
                    popularity: 100
                  }
                ]
              }
            }
          ]
        }
        allow(v1_api_client).to receive(:playlist_details).and_return(
          stub_as_resource(next_response),
          stub_as_resource(playlist_details_response)
        )
      end

      it 'requests playlist details multiple times' do
        api_request
        expect(v1_api_client).to have_received(:playlist_details).twice
      end

      it 'saves each playlist details' do
        expect { api_request }
          .to change(PlaylistTrack, :count).by(2)
          .and change(Track, :count).by(2)
          .and change(Artist, :count).by(2)
      end
    end
  end
end
