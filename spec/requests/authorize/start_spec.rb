# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authorizes' do
  describe 'GET /authorize/start' do
    subject(:api_request) { get '/authorize/start' }

    let(:authorize_url) { 'https://accounts.spotify.com/authorize' }
    let(:query) do
      {
        response_type: 'code',
        client_id: 'spotify-client-id',
        scope: 'playlist-modify-private',
        redirect_uri: 'http://localhost:3000/authorize/callback',
        state: 'state'
      }
    end
    let(:expected_url) { "#{authorize_url}?#{query.to_param}" }

    before do
      allow(SecureRandom).to receive(:hex).and_return('state')
    end

    it 'redirects to the Spotify authorize page' do
      expect(api_request).to redirect_to(expected_url)
    end
  end
end
