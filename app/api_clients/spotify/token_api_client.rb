# frozen_string_literal: true

module Spotify
  class TokenApiClient < ::ApplicationApiClient
    endpoint 'https://accounts.spotify.com/api'

    # error_handling json: { '$.errors.code': 10 }, raise: MyApiClient::Error

    # Request an Access Token
    # POST https://accounts.spotify.com/api/token
    #
    # @param code [String] Spotify authorization code
    # @param redirect_uri [String] specified redirect URI on the Spotify application
    # @return [Sawyer::Resource]
    # @raise [MyApiClient::Error]
    # @see https://developer.spotify.com/documentation/web-api/tutorials/code-flow
    def token(code:, redirect_uri:)
      body = {
        grant_type: 'authorization_code',
        code:,
        redirect_uri:
      }.to_query # see: https://github.com/ryz310/my_api_client/issues/122#issuecomment-546589068
      post 'token', body:, headers:
    end

    private

    def headers
      {
        'Content-Type': 'application/x-www-form-urlencoded',
        Authorization: "Basic #{encoded_credentials}"
      }
    end

    def encoded_credentials
      Base64.strict_encode64("#{client_id}:#{client_secret}")
    end

    def client_id
      Rails.application.credentials.spotify[:client_id]
    end

    def client_secret
      Rails.application.credentials.spotify[:client_secret]
    end
  end
end
