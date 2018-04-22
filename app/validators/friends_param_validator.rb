class FriendsParamValidator
  include ActiveModel::Validations
  attr_reader :friends, :requestor, :target

  validates :friends, presence: true
  validate  :friends_size, :friends_email_format, :emails_must_be_unique

  def initialize(friends)
    @friends   = friends
    @requestor = friends.try(:[], 0)
    @target    = friends.try(:[], 1)
  end

private

  def friends_size
    errors.add(:friends, "must provide 2 emails") if friends&.size != 2
  end

  def friends_email_format
    return if friends.blank?
    friends.each do |email|
      unless ValidEmail2::Address.new(email).valid?
        errors.add(:friends, "emails must be valid")
        break
      end
    end
  end

  def emails_must_be_unique
    return if friends.blank?
    if requestor == target
      errors.add(:friends, "emails must be unique")
    end
  end
end
