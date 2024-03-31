# frozen_string_literal: true

module Playlists
  class TracksController < ApplicationController
    # POST /playlists/:playlist_identifier/tracks
    def create
      target_track = Track.find_by(identifier: params[:track_identifier])
      user_api_client.add_playlist_tracks(playlist_identifier: current_playlist.identifier, tracks: [target_track])

      redirect_to playlist_path(current_playlist.identifier)
    end

    private

    def current_playlist
      @current_playlist ||= current_user.playlists.find_by!(identifier: params[:playlist_identifier])
    end

    def user_api_client
      Spotify::V1ApiClient.new(user: current_user)
    end
  end
end
