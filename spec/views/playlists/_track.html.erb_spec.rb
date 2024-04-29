# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'playlists/_track.html.erb' do
  let(:artist) { create(:artist, name: 'artist_name') }
  let(:track) { create(:track, artist:, name: 'track_name', image_url:) }
  let(:image_url) { 'https://example.com/image.jpg' }

  it 'renders image' do
    render partial: 'playlists/track', locals: { track: }

    expect(rendered).to have_xpath("//img[@src=\"#{image_url}\"]")
  end

  it 'renders track name' do
    render partial: 'playlists/track', locals: { track: }

    expect(rendered).to have_content('track_name')
  end

  it 'renders artist name' do
    render partial: 'playlists/track', locals: { track: }

    expect(rendered).to have_content('artist_name')
  end

  context 'when the track has no image' do
    let(:image_url) { nil }

    it 'does not render image' do
      render partial: 'playlists/track', locals: { track: }

      expect(rendered).to have_no_xpath('//img')
    end
  end
end
