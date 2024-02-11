# frozen_string_literal: true

class AuthorizeController < ApplicationController
  AUTHORIZE_URI = 'https://accounts.spotify.com/authorize'

  def start
    # TODO: save state
    redirect_to authorize_url, allow_other_host: true
  end

  def callback
    # TODO: verify state
    api_client = Spotify::TokenApiClient.new
    @credentials = api_client.token(code: params[:code], redirect_uri:)
    # TODO: get user info and create user data
  end

  private

  def authorize_url
    uri = URI.parse(AUTHORIZE_URI)
    uri.query = generate_query
    uri.to_s.gsub('+', '%20')
  end

  def generate_query
    {
      response_type: 'code',
      client_id:,
      scope:,
      redirect_uri:,
      state:
    }.to_param
  end

  def client_id
    Rails.application.credentials.spotify[:client_id]
  end

  def scope
    'playlist-modify-private'
  end

  def redirect_uri
    'http://localhost:3000/authorize/callback'
  end

  def state
    SecureRandom.hex(16)
  end
end
