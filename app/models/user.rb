# frozen_string_literal: true

# User model represents a user who participates in projects.
# Each user can be assigned to multiple projects with specific roles.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  validate :avatar_format
  validates :name, presence: true, length: { maximum: 50 },
                   format: { with: /\A[a-zA-Z0-9.-]+\z/, message: 'can only contain alphanumeric characters, hyphens,
         and periods' }
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

    if date_of_birth.present? && date_of_birth > Time.zone.today
      errors.add(:date_of_birth, "can't be in the future")
    elsif date_of_birth.present? && date_of_birth < 60.years.ago.to_date
      errors.add(:date_of_birth, "can't be older than 60 years")
    end
  end

  def avatar_format
    return unless avatar.attached?

    if !avatar.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:avatar, 'must be a JPEG, PNG, or GIF')
    elsif avatar.byte_size > 10.megabytes
      errors.add(:avatar, 'size must be less than 10MB')
    end
  end
end
