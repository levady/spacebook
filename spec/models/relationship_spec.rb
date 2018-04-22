require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "validations" do
    it { should validate_presence_of(:requestor) }
    it { should validate_presence_of(:target) }

    it "cannot add self as friend" do
      relationship = build(:relationship, requestor: "req@email.com", target: "req@email.com")
      expect(relationship).not_to be_valid
      expect(relationship.errors.messages[:target]).to eq ["cannot add self as friend"]
    end

    context "uniqueness" do
      it "raise an error when the combination of requestor and target is not unique" do
        create(:relationship, requestor: "req@email.com", target: "target@email.com")
        expect {
          create(:relationship, requestor: "req@email.com", target: "target@email.com")
        }.to raise_error(ActiveRecord::RecordNotUnique)
        expect(
          create(:relationship, requestor: "target@email.com", target: "req@email.com").requestor
        ).to eq("target@email.com")
      end
    end

    context "requestor" do
      it "does not allow invalid email format" do
        expect(build(:relationship, requestor: "foobar@email.com")).to be_valid
        expect(build(:relationship, requestor: "foobar")).not_to be_valid
      end
    end

    context "target" do
      it "does not allow invalid email format" do
        expect(build(:relationship, requestor: "foobar@email.com")).to be_valid
        expect(build(:relationship, requestor: "foobar")).not_to be_valid
      end
    end
  end

  describe ".create_friendship!" do
    context "given valid param" do
      let(:friends) { ["melon@email.com", "papaya@email.com"] }
      it "create relationship for both the requestor and the target" do
        Relationship.create_friendship!(*friends)
        expect(Relationship.count).to eq(2)
        expect(
          Relationship.find_by(requestor: "melon@email.com", target: "papaya@email.com", friend: true)
        ).not_to be_nil
        expect(
          Relationship.find_by(requestor: "papaya@email.com", target: "melon@email.com", friend: true)
        ).not_to be_nil
      end
    end

    context "given invalid param" do
      let(:friends) { ["melon@email.com", nil] }
      it "raise an error" do
        expect { Relationship.create_friendship!(*friends) }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Relationship.count).to eq(0)
      end
    end
  end

  describe "friends scope" do
    let!(:friends) { create_list(:relationship, 5, requestor: "totoro@ghibli.com") }
    let!(:non_friends) { create_list(:relationship, 2, requestor: "totoro@ghibli.com", friend: false) }
    let!(:others) { create_list(:relationship, 2, requestor: "no-face@ghibli.com") }

    it "fetches friends only" do
      expect(Relationship.friends_of("totoro@ghibli.com").count).to eq 5
    end
  end
end
