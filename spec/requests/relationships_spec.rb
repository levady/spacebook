require 'rails_helper'

RSpec.describe 'Relationships API', type: :request do
  describe "POST /relationships" do
    context "when the request is valid" do
      it "creates a relationship for both the requestor and the target" do
        post '/relationships', params: { friends: ["johnny-danger@booyah.com", "triggered@email.com"] }
        expect(json["success"]).to eq true
        expect(Relationship.count).to eq(2)
        expect(
          Relationship.find_by(requestor: "johnny-danger@booyah.com", target: "triggered@email.com", friend: true)
        ).not_to be_nil
        expect(
          Relationship.find_by(requestor: "triggered@email.com", target: "johnny-danger@booyah.com", friend: true)
        ).not_to be_nil
      end
    end

    context "when the request is invalid" do
      it "returns a proper error response" do
        # Invalid params
        post '/relationships', params: { friends: ["johnny-danger@booyah.com"] }
        expect(json["success"]).to eq false
        expect(json.dig("errors", "friends")).to eq ["must provide 2 emails"]

        # Invalid emails
        post '/relationships', params: { friends: ["johnny-danger@booyah", "asdasd"] }
        expect(json["success"]).to eq false
        expect(json.dig("errors", "friends")).to eq ["emails must be valid"]
      end
    end
  end

  describe "POST /friends" do
    context "when the request is valid" do
      let!(:friends) do
        create_list(:relationship, 5, requestor: "johnny-danger@booyah.com")
      end

      let(:non_friends) do
        create_list(:relationship, 3, requestor: "john-mclane@booyah.com")
      end

      it "returns a list of friends of the provided email" do
        post '/friends', params: { email: "johnny-danger@booyah.com" }
        expect(json["success"]).to eq true
        expect(json["count"]).to eq 5
      end
    end

    context "when the request is invalid" do
      it "returns a proper error response" do
        # Invalid params
        post '/friends', params: { email: nil }
        expect(json["success"]).to eq false
        expect(json.dig("errors", "email")).to eq ["can't be blank"]

        # Invalid emails
        post '/friends', params: { email: "asdasd" }
        expect(json["success"]).to eq false
        expect(json.dig("errors", "email")).to eq ["email must be valid"]
      end
    end
  end

  describe "POST /common_friends" do
    context "when the request is valid" do
      let!(:friend1) { create(:relationship, requestor: "kratos@gow.com", target: "zeus@gow.com") }
      let!(:friend2) { create(:relationship, requestor: "kratos@gow.com", target: "poseidon@gow.com") }

      let!(:friend3) { create(:relationship, requestor: "atreus@gow.com", target: "chronos@gow.com") }
      let!(:friend4) { create(:relationship, requestor: "atreus@gow.com", target: "poseidon@gow.com") }

      it "returns a list of common friends between 2 emails" do
        post '/common_friends', params: { friends: ["kratos@gow.com", "atreus@gow.com"] }
        expect(json["success"]).to eq true
        expect(json["count"]).to eq 1
        expect(json["friends"]).to match_array ["poseidon@gow.com"]
      end
    end

    context "when the request is invalid" do
      it "returns a proper error response" do
        # Invalid params
        post '/common_friends', params: { friends: ["hades@gow.com"] }
        expect(json["success"]).to eq false
        expect(json.dig("errors", "friends")).to eq ["must provide 2 emails"]

        # Invalid emails
        post '/common_friends', params: { friends: ["icarus@gow", "asdasd"] }
        expect(json["success"]).to eq false
        expect(json.dig("errors", "friends")).to eq ["emails must be valid"]
      end
    end
  end
end
