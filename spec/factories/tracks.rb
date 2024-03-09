# frozen_string_literal: true

FactoryBot.define do
  factory :track do
    artist
    identifier { 'identifier' }
    popularity { 1 }
    duration_ms { 1 }
    name { 'name' }
  end
end
