# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authorizes' do
  describe 'GET /authorize/callback' do
    subject(:api_request) { get '/authorize/callback', params: }

    let(:params) { { code: 'code', state: 'state' } }
    let(:api_client) do
      stub_api_client(
        Spotify::TokenApiClient,
        token: {}
      )
    end

    before do
      allow(Spotify::TokenApiClient).to receive(:new).and_return(api_client)
    end

    it 'requests access token' do
      api_request
      expect(api_client).to have_received(:token).with(code: 'code', redirect_uri: 'http://localhost:3000/authorize/callback')
    end
  end
end
