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

        # Requestor
        requestor = Relationship.find_by(requestor: "melon@email.com", target: "papaya@email.com")
        expect(requestor).not_to be_nil
        expect(requestor.friend).to eq true
        expect(requestor.following).to eq true

        # Target
        target = Relationship.find_by(requestor: "papaya@email.com", target: "melon@email.com")
        expect(target).not_to be_nil
        expect(target.friend).to eq true
        expect(target.following).to eq true
      end
    end

    context "given invalid param" do
      let(:friends) { ["melon@email.com", nil] }
      it "raise an error" do
        expect { Relationship.create_friendship!(*friends) }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Relationship.count).to eq(0)
      end
    end

    context "when there's a following relationship for requestor" do
      let!(:following) { create(:relationship, requestor: "papaya@email.com", target: "melon@email.com", following: true, friend: false) }
      it "update friend to true" do
        Relationship.create_friendship!("papaya@email.com", "melon@email.com")
        expect(following.reload.friend).to eq true
      end
    end

    context "when target is blocked" do
      let!(:following) { create(:relationship, requestor: "papaya@email.com", target: "melon@email.com", following: false, friend: false, block: true) }
      it "raise an error" do
        expect {
          Relationship.create_friendship!("papaya@email.com", "melon@email.com")
        }.to raise_error(ActiveRecord::RecordInvalid)
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

  describe "common friends scope" do
    let!(:friend1) { create(:relationship, requestor: "totoro@ghibli.com", target: "miyazaki@ghibli.com") }
    let!(:friend2) { create(:relationship, requestor: "totoro@ghibli.com", target: "takahata@ghibli.com") }
    let!(:friend3) { create(:relationship, requestor: "totoro@ghibli.com", target: "hisaishi@ghibli.com") }
    let!(:friend4) { create(:relationship, requestor: "totoro@ghibli.com", target: "suzuki@ghibli.com") }
    let!(:friend5) { create(:relationship, requestor: "totoro@ghibli.com", target: "yubaba@ghibli.com", friend: false) }

    let!(:friend6) { create(:relationship, requestor: "no-face@ghibli.com", target: "miyazaki@ghibli.com") }
    let!(:friend7) { create(:relationship, requestor: "no-face@ghibli.com", target: "haku@ghibli.com") }
    let!(:friend8) { create(:relationship, requestor: "no-face@ghibli.com", target: "hisaishi@ghibli.com") }
    let!(:friend9) { create(:relationship, requestor: "no-face@ghibli.com", target: "chihiro@ghibli.com") }
    let!(:friend10) { create(:relationship, requestor: "no-face@ghibli.com", target: "yubaba@ghibli.com") }

    it "fetches common friends only" do
      expect(Relationship.common_friends_of(["totoro@ghibli.com", "no-face@ghibli.com"]).pluck(:target).count).to eq 2
      expect(Relationship.common_friends_of(["totoro@ghibli.com", "no-face@ghibli.com"]).pluck(:target)).to match_array ["miyazaki@ghibli.com", "hisaishi@ghibli.com"]
    end
  end

  describe ".follow" do
    context "given valid params" do
      it "creates a relationship with following true" do
        relationship = Relationship.follow!("9S@nier.com", "2B@nier.com")
        expect(relationship.following).to eq true
        expect(relationship.friend).to eq false
      end

      it "update when there's already an existing relationship" do
        relationship = create(:relationship, requestor: "9S@nier.com", target: "2B@nier.com", following: false)
        following = Relationship.follow!("9S@nier.com", "2B@nier.com")
        expect(following.id).to eq relationship.id
        expect(relationship.reload.following).to eq true
        expect(relationship.reload.friend).to eq true
      end
    end

    context "given invalid params" do
      it "raise an error" do
        expect { Relationship.follow!("email", nil) }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Relationship.count).to eq(0)
      end
    end
  end

  describe ".block" do
    context "given valid params" do
      it "creates a relationship with block true, following false and friend false" do
        relationship = Relationship.block!("9S@nier.com", "2B@nier.com")
        expect(relationship.block).to eq true
        expect(relationship.following).to eq false
        expect(relationship.friend).to eq false
      end

      it "update when there's already an existing relationship" do
        relationship = create(:relationship, requestor: "9S@nier.com", target: "2B@nier.com", following: false)
        blocking = Relationship.block!("9S@nier.com", "2B@nier.com")
        expect(blocking.id).to eq relationship.id
        expect(relationship.reload.block).to eq true
        expect(relationship.following).to eq false
        expect(relationship.friend).to eq true
      end
    end

    context "given invalid params" do
      it "raise an error" do
        expect { Relationship.block!("email", nil) }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Relationship.count).to eq(0)
      end
    end
  end

  describe "update recipients scope" do
    let!(:friend1) { create(:relationship, target: "totoro@ghibli.com", requestor: "miyazaki@ghibli.com", friend: true) }
    let!(:friend2) { create(:relationship, target: "totoro@ghibli.com", requestor: "takahata@ghibli.com", following: true) }
    let!(:friend3) { create(:relationship, target: "totoro@ghibli.com", requestor: "hisaishi@ghibli.com", block: true) }
    let!(:friend4) { create(:relationship, target: "totoro@ghibli.com", requestor: "suzuki@ghibli.com", following: false, friend: false) }
    let!(:friend5) { create(:relationship, target: "totoro@ghibli.com", requestor: "yubaba@ghibli.com", friend: true, following: false, block: true) }
    let!(:friend6) { create(:relationship, target: "totoro@ghibli.com", requestor: "zeniba@ghibli.com", friend: true) }
    let!(:friend7) { create(:relationship, target: "totoro@ghibli.com", requestor: "kamaji@ghibli.com", friend: true) }

    it "fetches recipients" do
      expect(Relationship.update_recipients_for("totoro@ghibli.com").pluck(:requestor).count).to eq 4
      recipients = ["miyazaki@ghibli.com", "takahata@ghibli.com", "zeniba@ghibli.com", "kamaji@ghibli.com"]
      expect(Relationship.update_recipients_for(["totoro@ghibli.com", "no-face@ghibli.com"]).pluck(:requestor)).to match_array recipients
    end
  end
end
