
FactoryBot.define do
  factory :reservation do
    day{ "2022-07-18" }
    time_from{ "9:00" }
    user_id { Faker::Lorem.characters(number: 1) }
    number_of_ppl { Faker::Number.between(from: 1, to: 5) }
    start_time { "2022-07-18 00:00:00.000000000 +0900" }
  end
end