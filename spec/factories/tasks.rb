FactoryBot.define do
  factory :task do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    due_date { Faker::Date.forward(days: 7) }
    category
  end
end
