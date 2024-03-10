# frozen_string_literal: true

FactoryBot.define do
  factory :track do
    artist
    identifier { Faker::Alphanumeric.alpha(number: 10) }
    popularity { 100 }
    duration_ms { 100_000 }
    name { Faker::Music::RockBand.song }
  end
end
