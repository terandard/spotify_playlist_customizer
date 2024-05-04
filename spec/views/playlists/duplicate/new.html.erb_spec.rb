# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'playlists/duplicate/new.html.erb' do
  let(:playlist) { create(:playlist, identifier: 'identifier', name: 'playlist_name') }

  before do
    assign(:current_playlist, playlist)

    render
  end

  it 'renders the form with duplicate url' do
    expect(rendered).to have_xpath('//form[@action="/playlists/identifier/duplicate"]')
  end

  it 'shows playlist name on text field' do
    expect(rendered).to have_field 'name', with: 'playlist_name'
  end

  it 'renders the submit button' do
    expect(rendered).to have_button 'Duplicate'
  end
end
