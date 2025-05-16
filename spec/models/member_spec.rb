require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'associations' do
    it { should have_many(:assignments) }
    it { should have_many(:projects).through(:assignments) }
  end

  describe 'validations' do
    it 'validates avatar content type' do
      member = build(:member)
      file = fixture_file_upload(Rails.root.join('spec/fixtures/files/avatar.txt'), 'text/plain')
      member.avatar.attach(file)
      expect(member).to_not be_valid
      expect(member.errors[:avatar]).to include('must be a JPEG, PNG, or GIF')
    end

    it 'validates avatar size' do
      member = build(:member)
      big_file_path = Rails.root.join('spec/fixtures/files/big_avatar.png')
      File.open(big_file_path, 'wb') do |file|
        file.write('0' * 11.megabytes)
      end
      file = fixture_file_upload(big_file_path, 'image/png')
      member.avatar.attach(file)
      expect(member).to_not be_valid
      expect(member.errors[:avatar]).to include('size must be less than 10MB')
    end

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }

    it 'validates name format' do
      valid_member = build(:member, name: 'teo-123.ok')
      invalide_member = build(:member, name: 'teo@123')

      expect(valid_member).to be_valid
      expect(invalide_member).to_not be_valid
    end

    it { should validate_presence_of(:phone_number) }
    it { should validate_length_of(:phone_number).is_at_most(20) }
    it 'validates phone number format' do
      valid_member = build(:member, phone_number: '(+84) 123-456-7890')
      invalid_member = build(:member, phone_number: '1234567abc')
      expect(valid_member).to be_valid
      expect(invalid_member).to_not be_valid
    end

    it { should validate_presence_of(:date_of_birth) }
    it { should validate_presence_of(:position) }
    it { should validate_length_of(:information).is_at_most(300) }
  end

  describe 'enums' do
    it { should define_enum_for(:position).with_values(intern: 1, junior: 2, senior: 3, pm: 4, ceo: 5, cto: 6, bo: 7) }
  end

  describe 'custom validation -validate_date_of_birth' do
    it 'is invalid if date_of_birth is in the future' do
      member = build(:member, date_of_birth: Date.tomorrow)
      expect(member).to_not be_valid
      expect(member.errors[:date_of_birth]).to include('can\'t be in the future')
    end

    it 'is invalid if date_of_birth is older than 60 years' do
      member = build(:member, date_of_birth: 61.years.ago)
      expect(member).to_not be_valid
      expect(member.errors[:date_of_birth]).to include('can\'t be older than 60 years')
    end

    it 'is invalid if date_of_birth is not a valid date' do
      member = build(:member, date_of_birth: 'invalid_date')
      expect(member).to_not be_valid
      expect(member.errors[:date_of_birth]).to include('is not a valid date')
    end

    it 'is valid if date_of_birth is a valid date' do
      member = build(:member, date_of_birth: Date.today)
      expect(member).to be_valid
    end
  end
end
