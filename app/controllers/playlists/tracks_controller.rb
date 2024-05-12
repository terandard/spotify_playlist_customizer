# frozen_string_literal: true

module Playlists
  class TracksController < ApplicationController
    # POST /playlists/:playlist_identifier/tracks
    def create
      user_api_client.add_playlist_tracks(
        playlist_identifier: current_playlist.identifier,
        tracks: [target_track]
      )

      redirect_to playlist_path(current_playlist.identifier)
    end

    # DELETE /playlists/:playlist_identifier/tracks
    def destroy
      user_api_client.delete_playlist_tracks(
        playlist_identifier: current_playlist.identifier,
        tracks: [target_track]
      )

      current_playlist.playlist_tracks.find_by!(track: target_track).destroy!

      redirect_to playlist_path(current_playlist.identifier)
    end

    private

    def current_playlist
      @current_playlist ||= current_user.playlists.find_by!(identifier: params[:playlist_identifier])
    end

    def user_api_client
      Spotify::V1ApiClient.new(user: current_user)
    end

    def target_track
      @target_track ||= current_playlist.tracks.find_by!(identifier: params[:track_identifier])
    end
  end
end
