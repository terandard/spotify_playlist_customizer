# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    user
    identifier { 'identifier' }
  end
end
