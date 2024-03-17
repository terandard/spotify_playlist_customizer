# frozen_string_literal: true

module Playlists
  class DuplicateController < ApplicationController
    # GET /playlists/:identifier/duplicate
    def new
      @current_playlist = current_playlist
    end

    # POST /playlists/:identifier/duplicate
    def create
      response = user_api_client.create_playlist(name: params[:name])

      new_playlist = duplicate_playlist(response)

      tracks = current_playlist.playlist_tracks.map(&:track)
      user_api_client.add_playlist_tracks(playlist_identifier: new_playlist.identifier, tracks:)

      redirect_to playlist_path(new_playlist.identifier)
    end

    private

    def current_playlist
      @current_playlist ||= current_user.playlists.find_by!(identifier: params[:playlist_identifier])
    end

    def user_api_client
      Spotify::V1ApiClient.new(user: current_user)
    end

    # @param response [Sawyer::Resource]
    # @return [Playlist]
    def duplicate_playlist(response)
      new_playlist = current_user.playlists.create!(identifier: response['id'], name: response['name'])

      # rubocop:disable Rails/SkipsModelValidations
      new_playlist.playlist_tracks.insert_all!(
        current_playlist.playlist_tracks.map { |pt| { track_id: pt.track_id, position: pt.position } }
      )
      # rubocop:enable Rails/SkipsModelValidations

      new_playlist
    end
  end
end
