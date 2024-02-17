# frozen_string_literal: true

class AuthorizeController < ApplicationController
  AUTHORIZE_URI = 'https://accounts.spotify.com/authorize'

  class InvalidState < StandardError; end

  rescue_from InvalidState do
    redirect_to login_path
  end

  def start
    session[:state] = state

    redirect_to authorize_url, allow_other_host: true
  end

  def callback
    verify_state

    token_api_client = Spotify::TokenApiClient.new
    credentials = token_api_client.token(code: params[:code], redirect_uri:)

    v1_api_client = Spotify::V1ApiClient.new(access_token: credentials.access_token)
    user_info = v1_api_client.me

    user = User.find_or_initialize_by(identifier: user_info.id)
    user.update!(
      access_token: credentials.access_token,
      refresh_token: credentials.refresh_token
    )
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
    @state ||= SecureRandom.hex(16)
  end

  def verify_state
    raise InvalidState unless session[:state] == params[:state]
  end
end
