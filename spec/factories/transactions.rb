# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { Faker::Number.number(digits: 16).to_s }
    credit_card_expiration_date { '04/23' }
    result { %w[success failed].sample }
  end
end
