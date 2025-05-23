FactoryBot.define do
  factory :project do
    name { Faker::Alphanumeric.unique.alphanumeric(number: 8) }
    information { Faker::Lorem.paragraph }
    deadline { Faker::Date.backward(days: 30) }
    project_type { Project.project_types.keys.sample }
    status { Project.statuses.keys.sample }
  end
end
