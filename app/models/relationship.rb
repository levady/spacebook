class Relationship < ApplicationRecord
  validates :requestor, :target, presence: true, 'valid_email_2/email': { message: "email must be valid" }
  validate  :cannot_add_self

  scope :friends_of, -> (email) { where(requestor: email, friend: true) }
  scope :common_friends_of, -> (emails) { friends_of(emails).having("COUNT(target) = 2").group(:target) }

  def self.create_friendship!(requestor, target)
    transaction do
      add_friend!(requestor, target)
      add_friend!(target, requestor)
    end
  end

  def self.follow!(requestor, target)
    relationship = find_or_initialize_by(requestor: requestor, target: target)
    relationship.following = true
    relationship.save!
    relationship
  end

  def self.block!(requestor, target)
    relationship = find_or_initialize_by(requestor: requestor, target: target)
    relationship.block = true
    relationship.following = false
    relationship.save!
    relationship
  end

private

  def self.add_friend!(requestor, target)
    relationship = find_or_initialize_by(requestor: requestor, target: target)
    relationship.friend = true
    relationship.following = true
    relationship.save!
    relationship
  end

  def cannot_add_self
    if requestor == target
      errors.add(:target, "cannot add self as friend")
    end
  end
end
