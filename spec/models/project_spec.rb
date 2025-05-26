require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:assignments) }
    it { is_expected.to have_many(:members).through(:assignments) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(10) }

    it 'validates name format' do
      valid_project = build(:project, name: 'teo-123.ok')
      invalide_project = build(:project, name: 'teo@123')

      expect(valid_project).to be_valid
      expect(invalide_project).not_to be_valid
    end

    it { is_expected.to validate_length_of(:information).is_at_most(300) }
    it { is_expected.to validate_presence_of(:project_type) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:project_type).with_values(lap: 1, single: 2, acceptance: 3) }
    it { is_expected.to define_enum_for(:status).with_values(planned: 1, onhold: 2, doing: 3, done: 4, canceled: 5) }
  end

  describe 'custom validation -deadline_is_valid' do
    it 'is invalid if deadline is not a valid date' do
      project = build(:project, deadline: 'invalid_date')
      expect(project).not_to be_valid
      expect(project.errors[:deadline]).to include('is not a valid date')
    end

    it 'is valid if deadline is a valid date' do
      project = build(:project, deadline: Date.today)
      expect(project).to be_valid
    end
  end
end
