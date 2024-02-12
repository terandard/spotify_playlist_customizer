# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authorizes' do
  describe 'GET /authorize/callback' do
    subject(:api_request) { get '/authorize/callback', params: }

    let(:params) { { code: 'code', state: 'state' } }
    let(:token_api_client) { stub_api_client(Spotify::TokenApiClient, token: credentials) }
    let(:credentials) { { access_token: 'access_token', refresh_token: 'refresh_token' } }
    let(:v1_api_client) { stub_api_client(Spotify::V1ApiClient, me: { id: 'identifier' }) }

    before do
      allow(Spotify::TokenApiClient).to receive(:new).and_return(token_api_client)
      allow(Spotify::V1ApiClient).to receive(:new).and_return(v1_api_client)
    end

    it 'requests access token' do
      api_request
      expect(token_api_client).to have_received(:token).with(code: 'code', redirect_uri: 'http://localhost:3000/authorize/callback')
    end

    it 'requests user info' do
      api_request
      expect(v1_api_client).to have_received(:me)
    end

    context 'when the user does not exist' do
      it 'creates a user' do
        expect { api_request }.to change(User, :count).by(1)
      end

      it 'saves user info' do
        api_request
        user = User.last
        expect(user).to have_attributes(
          identifier: 'identifier',
          access_token: 'access_token',
          refresh_token: 'refresh_token'
        )
      end
    end

    context 'when the user exists' do
      before do
        create(
          :user,
          identifier: 'identifier',
          access_token: 'old_access_token',
          refresh_token: 'old_refresh_token'
        )
      end

      it 'does not create a user' do
        expect { api_request }.not_to change(User, :count)
      end

      it 'updates user info' do
        api_request
        user = User.last
        expect(user).to have_attributes(
          identifier: 'identifier',
          access_token: 'access_token',
          refresh_token: 'refresh_token'
        )
      end
    end
  end
end
