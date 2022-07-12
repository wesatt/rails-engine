FactoryBot.define do
  factory :customer do
    first_name { Faker::Games::Pokemon.name }
    last_name { Faker::Dessert.variety }
  end
end
