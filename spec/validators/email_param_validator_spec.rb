require 'rails_helper'

RSpec.describe EmailParamValidator, type: :model do
  subject { described_class.new(email)  }

  context "given valid email param" do
    let(:email) { "melon@email.com" }
    it { is_expected.to be_valid }
  end

  context "given invalid email param" do
    let(:email) { nil }
    it { is_expected.not_to be_valid }
  end

  context "given invalid email format" do
    let(:email) { "melon@email" }
    it { is_expected.not_to be_valid }
  end
end
