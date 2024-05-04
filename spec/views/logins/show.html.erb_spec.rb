# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'logins/show.html.erb' do
  before { render }

  it 'renders the login link' do
    expect(rendered).to have_link('Spotify Login', href: authorize_start_path)
  end
end
