# frozen_string_literal: true

# Assignment model connects a member to a project with a specific role.
class Assignment < ApplicationRecord
  belongs_to :project
  belongs_to :member
  validates :role, presence: true
  enum :role, {
    dev: 1,
    pl: 2,
    pm: 3,
    po: 4,
    sm: 5
  }
end
