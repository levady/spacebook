require 'rails_helper'

RSpec.describe FriendsParamValidator, type: :model do
  subject { described_class.new(friends)  }

  context "given valid friends param" do
    let(:friends) { ["melon@email.com", "papaya@email.com"] }
    it { is_expected.to be_valid }

    describe "#requestor" do
      subject { super().requestor }
      it { is_expected.to eq "melon@email.com" }
    end

    describe "#target" do
      subject { super().target }
      it { is_expected.to eq "papaya@email.com" }
    end
  end

  context "given invalid friends param" do
    [nil, [], ["mango@email.com"]].each do |param|
      let(:friends) { param }
      it { is_expected.not_to be_valid }
    end
  end

  context "given invalid email format" do
    let(:friends) { ["melon@email", "papaya"] }
    it { is_expected.not_to be_valid }
  end

  context "given not unique emails" do
    let(:friends) { ["melon@email.com", "melon@email.com"] }
    it { is_expected.not_to be_valid }
  end
end
