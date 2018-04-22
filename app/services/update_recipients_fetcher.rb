class UpdateRecipientsFetcher
  include ActiveModel::Validations

  attr_reader :sender, :text, :recipients

  validates :sender, :text, presence: true
  validate  :email_format

  def initialize(sender, text)
    @sender = sender
    @text  = text
    @recipients = []
  end

  def run
    @recipients = Relationship.update_recipients_for(sender).pluck(:requestor)
    @recipients.push(*email_extractor.extract(text))
    @recipients
  end

private

  def email_format
    return if sender.blank?
    errors.add(:sender, "email must be valid") unless ValidEmail2::Address.new(sender).valid?
  end

  def email_extractor
    @email_extractor ||= begin
      require 'email_extractor'
      EmailExtractor.new
    end
  end
end
