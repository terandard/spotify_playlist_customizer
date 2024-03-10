# frozen_string_literal: true

FactoryBot.define do
  factory :artist do
    identifier { Faker::Alphanumeric.alpha(number: 10) }
    name { Faker::Music::RockBand.name }
  end
end
