# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

user = User.new(
  email: 'lethitrang123@gmail.com',
  password: '123456',
  phone_number: Faker::PhoneNumber.phone_number,
  name: "#{Faker::Name.first_name}.#{Faker::Name.last_name}-#{rand(1000)}",
  date_of_birth: Faker::Date.between(from: 60.years.ago.to_date + 1.day, to: Date.today - 1.day),
  position: User.positions.keys.sample,
  information: Faker::Lorem.paragraph
)

avatar_path = Rails.root.join('spec/fixtures/files/avatar.png')
if File.exist?(avatar_path)
  user.avatar.attach(io: File.open(avatar_path), filename: 'avatar.png', content_type: 'image/png')
end

user.save!
