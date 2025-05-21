# frozen_string_literal: true

# Project model represents a project that involves multiple members.
class Project < ApplicationRecord
  has_many :assignments
  has_many :members, through: :assignments
  validates :name, presence: true, length: { maximum: 10 },
                   format: { with: /\A[a-zA-Z0-9.-]+\z/, message: 'can only contain alphanumeric characters, hyphens,
                   and periods' }
  validates :information, length: { maximum: 300 }
  validate :deadline_is_valid
  validates :project_type, presence: true
  enum :project_type, {
    lap: 1,
    single: 2,
    acceptance: 3
  }
  validates :status, presence: true
  enum :status, {
    planned: 1,
    onhold: 2,
    doing: 3,
    done: 4,
    canceled: 5
  }

  private

  def deadline_is_valid
    return if deadline.respond_to?(:to_date)

    errors.add(:deadline, 'is not a valid date')
  end
end
