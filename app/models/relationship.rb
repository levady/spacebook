class Relationship < ApplicationRecord
  validates :requestor, :target, presence: true, 'valid_email_2/email': true
  validate  :cannot_add_self

  scope :friends_of, -> (email) { where(requestor: email, friend: true) }

  def self.create_friendship!(requestor, target)
    transaction do
      create!(requestor: requestor, target: target, friend: true)
      create!(requestor: target, target: requestor, friend: true)
    end
  end

private

  def cannot_add_self
    if requestor == target
      errors.add(:target, "cannot add self as friend")
    end
  end
end
