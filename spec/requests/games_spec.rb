require "rails_helper"

RSpec.describe "Games", type: :request do
  describe "POST /api/games" do
    it "creates a game" do
      expect { post "/api/games" }.to change(Game, :count).by(1)
    end

    it "returns a created status" do
      post "/api/games"

      expect(response).to have_http_status(:created)
    end
  end
end
