FactoryBot.define do
  factory :tea do
    title { Faker::ElectricalComponents.active }
    description { Faker::Food.fruits }
    brew_time_seconds { Faker::Number.between(from: 60, to: 180) }
    temperature { Faker::Number.between(from: 150, to: 210) }
  end
end
