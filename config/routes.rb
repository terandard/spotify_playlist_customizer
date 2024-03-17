# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :login, only: :show
  resources :playlists, only: %i[index show], param: :identifier do
    scope module: :playlists do
      get :duplicate, to: 'duplicate#new'
      post :duplicate, to: 'duplicate#create'
    end
  end

  get 'authorize/start'
  get 'authorize/callback'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'logins#show'
end
