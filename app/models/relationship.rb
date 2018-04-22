class Relationship < ApplicationRecord
  validates :requestor, :target, presence: true
end
