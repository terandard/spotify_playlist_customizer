# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'playlists/index.html.erb' do
  let(:agent) { Sawyer::Agent.new('test') }
  let(:playlist_response) do
    Sawyer::Resource.new(
      agent, {
        id: 'id',
        name: 'name',
        images: [image_response],
        tracks: { total: 2 },
        owner: { display_name: 'display_name' }
      }
    )
  end
  let(:image_response) { Sawyer::Resource.new(agent, { url: image_url }) }
  let(:image_url) { 'http://example.png' }

  before do
    assign(:playlists, [playlist_response])
  end

  it 'renders the playlist image' do
    render
    expect(rendered).to have_xpath("//img[@src=\"#{image_url}\"]")
  end

  it 'renders a list of playlists' do
    render
    expect(rendered).to match(/name/)
    expect(rendered).to match(/display_name/)
    expect(rendered).to match(/2/)
  end

  it 'renders the playlist detail link' do
    render
    expect(rendered).to have_link('details', href: playlist_path('id'))
  end
end
