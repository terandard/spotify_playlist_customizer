# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    user
    identifier { Faker::Alphanumeric.alpha(number: 10) }
  end
end
