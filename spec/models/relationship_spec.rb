require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "validations" do
    it { should validate_presence_of(:requestor) }
    it { should validate_presence_of(:target) }

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
  end
end