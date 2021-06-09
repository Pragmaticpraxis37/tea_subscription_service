FactoryBot.define do
  factory :subscription do
    title { Faker::GreekPhilosophers.name }
    price { Faker::Commerce.price(range: 10..100.0) }
    status { "Active" }
    frequency_per_month { Faker::Number.between(from: 1, to: 4) }
  end
end
