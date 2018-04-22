class Relationship < ApplicationRecord
  validates :requestor, :target, presence: true, 'valid_email_2/email': true
  validate  :cannot_add_self

private

  def cannot_add_self
    if requestor == target
      errors.add(:target, "cannot add self as friend")
    end
  end
end
