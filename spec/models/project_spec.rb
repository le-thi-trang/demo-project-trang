require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should have_many(:assignments) }
    it { should have_many(:members).through(:assignments) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(10) }
    it 'validates name format' do
      valid_project = build(:project, name: 'teo-123.ok')
      invalide_project = build(:project, name: 'teo@123')

      expect(valid_project).to be_valid
      expect(invalide_project).to_not be_valid
    end

    it { should validate_length_of(:information).is_at_most(300) }
    it { should validate_presence_of(:project_type) }
    it { should validate_presence_of(:status) }
  end

  describe 'enums' do
    it { should define_enum_for(:project_type).with_values(lap: 1, single: 2, acceptance: 3) }
    it { should define_enum_for(:status).with_values(planned: 1, onhold: 2, doing: 3, done: 4, canceled: 5) }
  end

  describe 'custom validation -deadline_is_valid' do
    it 'is invalid if deadline is not a valid date' do
      project = build(:project, deadline: 'invalid_date')
      expect(project).to_not be_valid
      expect(project.errors[:deadline]).to include('is not a valid date')
    end

    it 'is valid if deadline is a valid date' do
      project = build(:project, deadline: Date.today)
      expect(project).to be_valid
    end
  end
end
