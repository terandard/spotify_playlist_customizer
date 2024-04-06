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
    playlist_items = response['items']
    save_playlist_details(playlist_items)
  end

  # GET /playlists/:identifier/recommendations
  def recommendations
    response = user_api_client.recommendations(tracks: current_playlist.tracks.sample(5))
    @recommendations = save_recommendations(response['tracks'])
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
      artist = create_or_find_artist(item.track.artists.first)

      track = create_or_find_track(item.track, artist)

      current_playlist.playlist_tracks.create!(track:, position: index)
    end
  end

  # return [Artist]
  def create_or_find_artist(artist)
    Artist.create_or_find_by!(identifier: artist.id) do |a|
      a.name = artist.name
      a.genres = artist.genres
      a.popularity = artist.popularity
    end
  end

  # return [Track]
  def create_or_find_track(track, artist)
    Track.create_or_find_by!(identifier: track.id) do |t|
      t.artist = artist
      t.popularity = track.popularity
      t.duration_ms = track.duration_ms
      t.name = track.name
      t.image_url = track.album.images.first&.url
    end
  end

  # @param tracks [Array<Sawyer::Resource>]
  # @return [Array<Track>]
  def save_recommendations(tracks)
    tracks.map do |track|
      artist = create_or_find_artist(track.artists.first)
      create_or_find_track(track, artist)
    end
  end
end
