# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Application' do
  subject(:api_request) { get test_path }

  let(:mock_controller) do
    Class.new ApplicationController do
      def index
        current_user
        render status: :ok, plain: 'ok'
      end
    end
  end

  before do
    stub_const('TestController', mock_controller)
    # ルーティングの上書き
    Rails.application.routes.disable_clear_and_finalize = true
    Rails.application.routes.draw do
      get 'test', to: 'test#index'
    end
    Rails.application.routes.disable_clear_and_finalize = false
  end

  after do
    # ルーティングを元に戻す
    Rails.application.reload_routes!
  end

  context 'when the user is not logged in' do
    it 'redirects to the login page' do
      expect(api_request).to redirect_to(login_path)
    end
  end

  context 'when the user is logged in' do
    before do
      create(:user, identifier: 'identifier')
      allow_any_instance_of(TestController).to receive(:session).and_return(user_identifier: 'identifier') # rubocop:disable RSpec/AnyInstance
    end

    it 'returns 200' do
      api_request
      expect(response).to have_http_status(:success)
    end
  end
end
