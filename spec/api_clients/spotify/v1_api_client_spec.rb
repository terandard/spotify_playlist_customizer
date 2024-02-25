# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spotify::V1ApiClient, type: :api_client do
  let(:api_client) { described_class.new(user:, access_token:) }
  let(:user) do
    create(
      :user,
      access_token:,
      refresh_token: 'refresh_token',
      expires_at:
    )
  end
  let(:access_token) { 'access_token' }
  let(:expires_at) { 1.hour.from_now }
  let(:headers) do
    {
      'Content-Type': 'application/json',
      Authorization: "Bearer #{access_token}"
    }
  end

  before { freeze_time }

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

  describe '#initialize' do
    let(:token_api_client) { stub_api_client(Spotify::TokenApiClient, refresh: credentials) }
    let(:credentials) do
      {
        access_token: 'new_access_token',
        refresh_token: 'new_refresh_token',
        expires_in: 3600
      }
    end

    before do
      allow(Spotify::TokenApiClient).to receive(:new).and_return(token_api_client)
    end

    context 'when the user is not given' do
      let(:user) { nil }

      it 'does not refresh the access token' do
        api_client
        expect(token_api_client).not_to have_received(:refresh)
      end
    end

    context 'when the user is given' do
      context 'when the access token is expired' do
        let(:expires_at) { 1.hour.ago }

        it 'refreshes the access token' do
          api_client
          expect(token_api_client).to have_received(:refresh).with(refresh_token: 'refresh_token')
        end

        it 'updates the user' do
          api_client
          expect(user.reload).to have_attributes(
            access_token: 'new_access_token',
            refresh_token: 'new_refresh_token',
            expires_at: 3600.seconds.from_now
          )
        end
      end

      context 'when the access token is not expired' do
        it 'does not refresh the access token' do
          api_client
          expect(token_api_client).not_to have_received(:refresh)
        end
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

  describe '#my_playlists' do
    subject(:api_request) { api_client.my_playlists }

    it_behaves_like 'to handle errors'

    it do
      expect { api_request }
        .to request_to(:get, 'https://api.spotify.com/v1/me/playlists')
        .with(headers:)
    end
  end
end
