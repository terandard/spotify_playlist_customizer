# frozen_string_literal: true

module Spotify
  class V1ApiClient < ::ApplicationApiClient
    endpoint 'https://api.spotify.com/v1'

    # error_handling json: { '$.errors.code': 10 }, raise: MyApiClient::Error

    def initialize(access_token:)
      @access_token = access_token
    end

    # GET https://api.spotify.com/v1/me
    #
    # @return [Sawyer::Resource] user profile information
    # @raise [MyApiClient::Error]
    # @see https://developer.spotify.com/documentation/web-api/reference/get-current-users-profile
    def me
      get 'me', headers:
    end

    private

    attr_reader :access_token

    def headers
      {
        'Content-Type': 'application/json',
        Authorization: "Bearer #{access_token}"
      }
    end
  end
end
