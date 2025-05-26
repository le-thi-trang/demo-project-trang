require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates avatar content type' do
      user = build(:user)
      file = fixture_file_upload(Rails.root.join('spec/fixtures/files/avatar.txt'), 'text/plain')
      user.avatar.attach(file)
      expect(user).not_to be_valid
      expect(user.errors[:avatar]).to include('must be a JPEG, PNG, or GIF')
    end

    it 'validates avatar size' do
      user = build(:user)
      big_file_path = Rails.root.join('spec/fixtures/files/big_avatar.png')
      File.binwrite(big_file_path, '0' * 11.megabytes)
      file = fixture_file_upload(big_file_path, 'image/png')
      user.avatar.attach(file)
      expect(user).not_to be_valid
      expect(user.errors[:avatar]).to include('size must be less than 10MB')
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }

    it 'validates name format' do
      valid_user = build(:user, name: 'teo-123.ok')
      invalid_user = build(:user, name: 'teo@123')

      expect(valid_user).to be_valid
      expect(invalid_user).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:phone_number) }

    it 'validates phone number format' do
      valid_user = build(:user, phone_number: '(+84) 123-456-7890')
      invalid_user = build(:user, phone_number: '1234567abc')
      expect(valid_user).to be_valid
      expect(invalid_user).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_length_of(:phone_number).is_at_most(20) }

    it 'validates phone number format' do
      valid_user = build(:user, phone_number: '(+84) 123-456-7890')
      invalid_user = build(:user, phone_number: '1234567abc')
      expect(valid_user).to be_valid
      expect(invalid_user).not_to be_valid
    end
  end

  describe 'enums' do
    it {
      expect(subject).to define_enum_for(:position).with_values(intern: 1, junior: 2, senior: 3, pm: 4, ceo: 5, cto: 6,
                                                                bo: 7)
    }
  end

  describe 'custom validation -validate_date_of_birth' do
    it 'is invalid if date_of_birth is in the future' do
      user = build(:user, date_of_birth: Date.tomorrow)
      expect(user).not_to be_valid
      expect(user.errors[:date_of_birth]).to include('can\'t be in the future')
    end

    it 'is invalid if date_of_birth is older than 60 years' do
      user = build(:user, date_of_birth: 61.years.ago)
      expect(user).not_to be_valid
      expect(user.errors[:date_of_birth]).to include('can\'t be older than 60 years')
    end

    it 'is invalid if date_of_birth is not a valid date' do
      user = build(:user, date_of_birth: 'invalid_date')
      expect(user).not_to be_valid
      expect(user.errors[:date_of_birth]).to include('is not a valid date')
    end

    it 'is valid if date_of_birth is a valid date' do
      user = build(:user, date_of_birth: Date.today)
      expect(user).to be_valid
    end
  end
end
