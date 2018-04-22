class EmailParamValidator
  include ActiveModel::Validations
  attr_reader :email

  validates :email, presence: true
  validate  :email_format

  def initialize(email)
    @email = email
  end

private

  def email_format
    return if email.blank?
    errors.add(:email, "email must be valid") unless ValidEmail2::Address.new(email).valid?
  end
end
