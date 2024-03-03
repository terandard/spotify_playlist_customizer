# frozen_string_literal: true

class PlaylistsController < ApplicationController
  # GET /playlists
  def index
    response = user_api_client.my_playlists
    @playlists = response['items']
    save_playlists(@playlists)
  end

  # GET /playlists/:identifier
  def show
    response = user_api_client.playlist_details(playlist_id: params[:identifier])
    @playlist_items = response['items']
  end

  private

  def user_api_client
    Spotify::V1ApiClient.new(user: current_user)
  end

  def save_playlists(playlists)
    playlists.each do |playlist|
      current_user
        .playlists
        .find_or_initialize_by(identifier: playlist.id)
        .update!(
          name: playlist.name,
          image_url: playlist.images.first&.url
        )
    end
  end
end
