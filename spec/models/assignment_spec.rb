require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:member) }
  end

  describe 'validations' do
    it { should validate_presence_of(:role) }
    it { should define_enum_for(:role).with_values(dev: 1, pl: 2, pm: 3, po: 4, sm: 5) }
  end
end
