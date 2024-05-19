# frozen_string_literal: true

module Playlists
  class TracksController < ApplicationController
    # POST /playlists/:playlist_identifier/tracks
    def create
      position = current_playlist.playlist_tracks.count

      user_api_client.add_playlist_tracks(
        playlist_identifier: current_playlist.identifier,
        tracks: [create_target_track],
        position:
      )

      current_playlist.playlist_tracks.create!(track: create_target_track, position:)

      redirect_to playlist_path(current_playlist.identifier)
    end

    # DELETE /playlists/:playlist_identifier/tracks
    def destroy
      user_api_client.delete_playlist_tracks(
        playlist_identifier: current_playlist.identifier,
        tracks: [delete_target_track]
      )

      current_playlist.playlist_tracks.find_by!(track: delete_target_track).destroy!

      redirect_to playlist_path(current_playlist.identifier)
    end

    private

    def current_playlist
      @current_playlist ||= current_user.playlists.find_by!(identifier: params[:playlist_identifier])
    end

    def user_api_client
      Spotify::V1ApiClient.new(user: current_user)
    end

    def create_target_track
      @create_target_track ||= Track.find_by!(identifier: params[:track_identifier])
    end

    def delete_target_track
      @delete_target_track ||= current_playlist.tracks.find_by!(identifier: params[:track_identifier])
    end
  end
end
