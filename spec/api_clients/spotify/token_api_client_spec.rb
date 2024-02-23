# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spotify::TokenApiClient, type: :api_client do
  let(:api_client) { described_class.new }
  let(:headers) do
    {
      'Content-Type': 'application/x-www-form-urlencoded',
      Authorization: "Basic #{encoded_credentials}"
    }
  end
  let(:encoded_credentials) do
    Base64.strict_encode64(
      'spotify-client-id:spotify-client-secret'
    )
  end

  shared_examples 'to handle errors' do
    context 'when the API returns 200 OK' do
      it do
        expect { api_request }
          .not_to be_handled_as_an_error
          .when_receive(status_code: 200)
      end
    end

    context 'when the API returns 400 Bad Request' do
      it do
        expect { api_request }
          .to be_handled_as_an_error(MyApiClient::ClientError::BadRequest)
          .when_receive(status_code: 400)
      end
    end
  end

  describe '#token' do
    subject(:api_request) { api_client.token(code:, redirect_uri:) }

    let(:code) { 'code' }
    let(:redirect_uri) { 'http://localhost:3000/authorize/callback' }
    let(:expected_body) do
      {
        grant_type: 'authorization_code',
        code:,
        redirect_uri:
      }.to_query
    end

    it_behaves_like 'to handle errors'

    it do
      expect { api_request }
        .to request_to(:post, 'https://accounts.spotify.com/api/token')
        .with(headers:, body: expected_body)
    end
  end
end
