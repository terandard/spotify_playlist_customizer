# frozen_string_literal: true

class PlaylistsController < ApplicationController
  def index
    user_api_client = Spotify::V1ApiClient.new(user: current_user)
    response = user_api_client.my_playlists
    @playlists = response['items']
  end
end
