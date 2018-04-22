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
end
