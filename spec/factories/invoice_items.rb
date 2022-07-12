FactoryBot.define do
  factory :invoice_item do
    item { nil }
    invoice { nil }
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
  end
end
