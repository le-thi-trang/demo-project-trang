# frozen_string_literal: true

# Member model represents a user who participates in projects.
# Each member can be assigned to multiple projects with specific roles.
class Member < ApplicationRecord
  has_many :assignments
  has_many :projects, through: :assignments
  has_one_attached :avatar

  validates :avatar, content_type: ['image/jpeg', 'image/png', 'image/gif'],
                     size: { less_than: 10.megabytes }
  validates :name, presence: true, length: { maximum: 50 },
                   format: { with: /\A[a-zA-Z0-9.-]+\z/, message: 'can only contain alphanumeric characters, hyphens,
                   and periods' }
  validates :information, length: { maximum: 300 }
  validates :phone_number, presence: true, length: { maximum: 20 },
                           format: { with: %r{\A[0-9()/.\-+ ]+\z}, message: 'only numbers allowed' }
  validates :date_of_birth, presence: true
  validate :validate_date_of_birth
  validates :position, presence: true

  enum :position, {
    intern: 1,
    junior: 2,
    senior: 3,
    pm: 4,
    ceo: 5,
    cto: 6,
    bo: 7
  }

  private

  def validate_date_of_birth
    unless date_of_birth.is_a?(Date)
      errors.add(:date_of_birth, 'is not a valid date')
      return
    end

    if date_of_birth.present? && date_of_birth > Date.today
      errors.add(:date_of_birth, "can't be in the future")
    elsif date_of_birth.present? && date_of_birth < 60.years.ago.to_date
      errors.add(:date_of_birth, "can't be older than 60 years")
    end
  end
end
