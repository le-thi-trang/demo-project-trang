FactoryBot.define do
  factory :member do
    name { 'John.Doe-123' }
    phone_number { Faker::PhoneNumber.phone_number }
    date_of_birth { Faker::Date.backward(days: 365 * 25) }
    position { Member.positions.keys.sample }
    information { Faker::Lorem.paragraph }

    after(:build) do |member|
      avatar_path = Rails.root.join('spec/fixtures/files/avatar.png')
      if File.exist?(avatar_path)
        member.avatar.attach(io: File.open(avatar_path),
                             filename: 'avatar.png',
                             content_type: 'image/png')
      end
    end
  end
end
