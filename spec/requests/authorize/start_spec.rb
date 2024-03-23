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
        scope: 'playlist-modify-private playlist-modify-public',
        redirect_uri: 'http://localhost:3000/authorize/callback',
        state:
      }
    end
    let(:expected_url) { "#{authorize_url}?#{query.to_param.gsub('+', '%20')}" }
    let(:state) { 'state' }
    let(:session) do
      instance_double(ActionDispatch::Request::Session)
    end

    before do
      allow(SecureRandom).to receive(:hex).and_return(state)

      # SecureRandom.hex をモックすると session に保存する際に FrozenError が発生するので、session もモックしている
      allow_any_instance_of(AuthorizeController).to receive(:session).and_return(session) # rubocop:disable RSpec/AnyInstance
      allow(session).to receive(:[]=)
    end

    it 'redirects to the Spotify authorize page' do
      expect(api_request).to redirect_to(expected_url)
    end

    it 'stores the state in the session' do
      api_request
      expect(session).to have_received(:[]=).with(:state, state)
    end
  end
end
