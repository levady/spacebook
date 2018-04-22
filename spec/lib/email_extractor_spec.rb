require 'rails_helper'
require 'email_extractor'

RSpec.describe EmailExtractor do
  subject { described_class.new.extract(string) }

  let(:string) { "this string has 3 emails to be extracted a@email.com, b@email.com and c@email.com" }

  describe "#extract" do
    it { is_expected.to match_array(["a@email.com", "b@email.com", "c@email.com"]) }

    context "blank string" do
      subject { described_class.new.extract(nil) }
      it { is_expected.to match_array([]) }
    end
  end
end
