# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    identifier { Faker::Alphanumeric.alpha(number: 10) }
    access_token { 'access_token' }
    refresh_token { 'refresh_token' }
  end
end
