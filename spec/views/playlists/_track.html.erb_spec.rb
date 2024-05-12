# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'playlists/_track.html.erb' do
  let(:artist) { create(:artist, name: 'artist_name') }
  let(:track) { create(:track, artist:, identifier: 'track_identifier', name: 'track_name', image_url:) }
  let(:image_url) { 'https://example.com/image.jpg' }
  let(:playlist) { create(:playlist, identifier: 'playlist_identifier') }
  let(:show_delete) { false }

  before { render partial: 'playlists/track', locals: { track:, playlist:, show_delete: } }

  it 'renders image' do
    expect(rendered).to have_xpath("//img[@src=\"#{image_url}\"]")
  end

  it 'renders track name' do
    expect(rendered).to have_content('track_name')
  end

  it 'renders artist name' do
    expect(rendered).to have_content('artist_name')
  end

  context 'when the track has no image' do
    let(:image_url) { nil }

    it 'does not render image' do
      expect(rendered).to have_no_xpath('//img')
    end
  end

  context 'when show delete link' do
    let(:show_delete) { true }

    it 'renders delete link' do
      expect(rendered)
        .to have_link('Delete', href: playlist_tracks_path('playlist_identifier', track_identifier: 'track_identifier'))
    end
  end
end
