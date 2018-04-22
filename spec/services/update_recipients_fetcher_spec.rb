require 'rails_helper'

RSpec.describe UpdateRecipientsFetcher, type: :model do
  it "validate presence of email" do
    expect(described_class.new(nil, "strong")).not_to be_valid
  end

  it "validate presence of text" do
    expect(described_class.new("email@email.com", nil)).not_to be_valid
  end

  it "validate email format" do
    expect(described_class.new("email@email", "test with email a@b.com")).not_to be_valid
  end

  describe "#run" do
    subject { described_class.new("totoro@ghibli.com", "test with email a@b.com").run }
    let!(:friend1) { create(:relationship, target: "totoro@ghibli.com", requestor: "miyazaki@ghibli.com", friend: true) }
    let!(:friend2) { create(:relationship, target: "totoro@ghibli.com", requestor: "takahata@ghibli.com", following: true) }
    let!(:friend3) { create(:relationship, target: "totoro@ghibli.com", requestor: "hisaishi@ghibli.com", block: true) }
    let!(:friend4) { create(:relationship, target: "totoro@ghibli.com", requestor: "suzuki@ghibli.com", following: false, friend: false) }
    let!(:friend5) { create(:relationship, target: "totoro@ghibli.com", requestor: "yubaba@ghibli.com", friend: true, following: false, block: true) }
    let!(:friend6) { create(:relationship, target: "totoro@ghibli.com", requestor: "zeniba@ghibli.com", friend: true) }
    let!(:friend7) { create(:relationship, target: "totoro@ghibli.com", requestor: "kamaji@ghibli.com", friend: true) }

    it { is_expected.to match_array(["miyazaki@ghibli.com", "takahata@ghibli.com", "zeniba@ghibli.com", "kamaji@ghibli.com", "a@b.com"]) }
  end
end
