FactoryBot.define do
  factory :assignment do
    project
    member
    role { Assignment.roles.keys.sample }
  end
end
