# frozen_string_literal: true

module Spotify
  class V1ApiClient < ::ApplicationApiClient
    endpoint 'https://api.spotify.com/v1'

    # error_handling json: { '$.errors.code': 10 }, raise: MyApiClient::Error

    def initialize(user:, access_token: nil)
      @access_token = access_token

      return if user.blank?

      @user = user
      @access_token = user.access_token
      @refresh_token = user.refresh_token
      @expires_at = user.expires_at
      verify_expiration
    end

    # GET https://api.spotify.com/v1/me
    #
    # @return [Sawyer::Resource] user profile information
    # @raise [MyApiClient::Error]
    # @see https://developer.spotify.com/documentation/web-api/reference/get-current-users-profile
    def me
      get 'me', headers:
    end

    # GET https://api.spotify.com/v1/me/playlists
    #
    # @return [Sawyer::Resource] a list of the playlists owned or followed by the current user
    # @raise [MyApiClient::Error]
    # @see https://developer.spotify.com/documentation/web-api/reference/get-a-list-of-current-users-playlists
    def my_playlists
      get 'me/playlists', headers:
    end

    # GET https://api.spotify.com/v1/playlists/#{playlist_id}/tracks
    #
    # @param playlist_id [String] The Spotify ID for the playlist.
    # @return [Sawyer::Resource] Get full details of the items of a playlist owned by a Spotify user.
    # @raise [MyApiClient::Error]
    # @see https://developer.spotify.com/documentation/web-api/reference/get-playlists-tracks
    def playlist_details(playlist_id:)
      query = { limit: 50 }
      get "/playlists/#{playlist_id}/tracks", query:, headers:
    end

    # POST https://api.spotify.com/v1/users/{user_id}/playlists
    #
    # @param name [String] The playlist name.
    # @return [Sawyer::Resource] Get a created playlist.
    # @raise [MyApiClient::Error]
    # @see https://developer.spotify.com/documentation/web-api/reference/create-playlist
    def create_playlist(name:)
      body = { name: }
      post "/users/#{user.identifier}/playlists", body:, headers:
    end

    # POST https://api.spotify.com/v1/playlists/{playlist_id}/tracks
    #
    # @param playlist_identifier [String] The playlist identifier.
    # @param tracks [Array<Track>] A list of tracks.
    # @param position [Integer] The position to insert the tracks, a zero-based index.
    # @return [Sawyer::Resource] A snapshot ID for the playlist.
    # @raise [MyApiClient::Error]
    # @see https://developer.spotify.com/documentation/web-api/reference/add-tracks-to-playlist
    def add_playlist_tracks(playlist_identifier:, tracks:, position: 0)
      uris = tracks.map { |track| "spotify:track:#{track.identifier}" }
      body = { position:, uris: }
      post "/playlists/#{playlist_identifier}/tracks", body:, headers:
    end

    # GET https://api.spotify.com/v1/recommendations
    #
    # @param seed_tracks [Array<Track>] A list of tracks.
    # @return [Sawyer::Resource] A set of recommendations. Maximum: 5 seed tracks.
    # @raise [MyApiClient::Error]
    # @see https://developer.spotify.com/documentation/web-api/reference/get-recommendations
    def recommendations(tracks:)
      seed_tracks = tracks.map(&:identifier).join(',')
      query = { seed_tracks: }
      get '/recommendations', query:, headers:
    end

    private

    attr_reader :user, :access_token, :refresh_token, :expires_at

    def headers
      {
        'Content-Type': 'application/json',
        Authorization: "Bearer #{access_token}"
      }
    end

    def verify_expiration
      return if expires_at.future?

      token_refresh
    end

    def token_refresh
      credentials = Spotify::TokenApiClient.new.refresh(refresh_token:)
      user.update!(
        access_token: credentials.access_token,
        refresh_token: credentials.refresh_token,
        expires_at: credentials.expires_in.seconds.from_now
      )
      @access_token = credentials.access_token
      @refresh_token = credentials.refresh_token
      @expires_at = credentials.expires_in.seconds.from_now
    end
  end
end
