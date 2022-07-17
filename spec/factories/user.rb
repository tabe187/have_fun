FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 5) }
    sequence :mail do |n|
      "test#{n}@example.com"
    end
    password { '123456' }
  end
end