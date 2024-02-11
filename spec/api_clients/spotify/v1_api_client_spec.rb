# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spotify::V1ApiClient, type: :api_client do
  let(:api_client) { described_class.new(access_token:) }
  let(:access_token) { 'access_token' }
  let(:headers) do
    {
      'Content-Type': 'application/json',
      Authorization: "Bearer #{access_token}"
    }
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

  describe '#me' do
    subject(:api_request) { api_client.me }

    it_behaves_like 'to handle errors'

    it do
      expect { api_request }
        .to request_to(:get, 'https://api.spotify.com/v1/me')
        .with(headers:)
    end
  end
end
