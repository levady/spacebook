class Relationship < ApplicationRecord
  validates :requestor, :target, presence: true, 'valid_email_2/email': true
end
