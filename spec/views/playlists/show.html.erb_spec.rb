# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'playlists/show.html.erb' do
  let(:playlist) { create(:playlist, identifier: 'identifier') }

  before do
    assign(:current_playlist, playlist)

    track = create(:track, identifier: 'track_identifier', name: 'track_name')
    create(:playlist_track, playlist:, track:)

    render
  end

  it 'renders back link to playlist index' do
    expect(rendered).to have_link('Back', href: playlists_path)
  end

  it 'renders duplicate link' do
    expect(rendered).to have_link('Duplicate', href: playlist_duplicate_path('identifier'))
  end

  it 'renders sync link' do
    expect(rendered).to have_link('Sync', href: sync_playlist_path('identifier'))
  end

  it 'renders track component' do
    expect(rendered).to have_content('track_name')
  end

  it 'renders track delete link' do
    expect(rendered)
      .to have_link('Delete', href: playlist_tracks_path('identifier', track_identifier: 'track_identifier'))
  end
end
