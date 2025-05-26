FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'Password123!' }
    phone_number { Faker::PhoneNumber.phone_number }
    name { Faker::Internet.username(specifier: 5..15).gsub(/[^a-zA-Z0-9.-]/, '') }
    date_of_birth { Faker::Date.between(from: 60.years.ago.to_date + 1.day, to: Date.today - 1.day) }
    position { User.positions.keys.sample }
    information { Faker::Lorem.paragraph }
  end

  after(:build) do |user|
    avatar_path = Rails.root.join('spec/fixtures/files/avatar.png')
    if File.exist?(avatar_path) && user.respond_to?(:avatar)
      user.avatar.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/avatar.png')),
        filename: 'avatar.png',
        content_type: 'image/png'
      )
    end
  end
end
