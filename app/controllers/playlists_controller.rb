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
    response = user_api_client.playlist_details(playlist_id: current_playlist.identifier)
    @playlist_items = response['items']
    save_playlist_details(@playlist_items)
  end

  private

  def current_playlist
    @current_playlist ||= current_user.playlists.find_by!(identifier: params[:identifier])
  end

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

  def save_playlist_details(playlist_items)
    current_playlist.playlist_tracks.destroy_all

    playlist_items.each_with_index do |item, index|
      artist = create_or_find_artist(item)

      track = create_or_find_track(item, artist)

      current_playlist.playlist_tracks.create!(track:, position: index)
    end
  end

  # return [Artist]
  def create_or_find_artist(item)
    artist = item.track.artists.first
    Artist.create_or_find_by!(identifier: artist.id) do |a|
      a.name = artist.name
      a.genres = artist.genres
      a.popularity = artist.popularity
    end
  end

  # return [Track]
  def create_or_find_track(item, artist)
    track = item.track
    Track.create_or_find_by!(identifier: track.id) do |t|
      t.artist = artist
      t.popularity = track.popularity
      t.duration_ms = track.duration_ms
      t.name = track.name
      t.image_url = track.album.images.first&.url
    end
  end
end
