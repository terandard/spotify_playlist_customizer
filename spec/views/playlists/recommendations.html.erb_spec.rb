# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'playlists/recommendations.html.erb' do
  let(:playlist) { create(:playlist, identifier: 'identifier') }
  let(:track) { create(:track, identifier: 'track_identifier', name: 'track_name') }

  before do
    assign(:current_playlist, playlist)
    assign(:recommendations, [track])
  end

  it 'renders the back link to playlist detail' do
    render

    expect(rendered).to have_link('Back', href: playlist_path('identifier'))
  end

  it 'renders the track add link' do
    render

    expect(rendered).to have_link('Add', href: playlist_tracks_path('identifier', track_identifier: 'track_identifier'))
  end

  it 'renders track component' do
    render

    expect(rendered).to have_content('track_name')
  end
end
