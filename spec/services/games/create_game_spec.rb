# frozen_string_literal: true

require "rails_helper"

RSpec.describe Games::CreateGame do
  describe ".run" do
    it "creates a game" do
      expect { described_class.run }.to change(Game, :count).by(1)
    end

    it "returns a persisted game" do
      game = described_class.run

      expect(game).to be_persisted
    end

    it "sets the answer to one of the available phrases" do
      game = described_class.run

      expect(described_class::PHRASES).to include(game.answer)
    end

    it "starts the game in the playing state" do
      game = described_class.run

      expect(game).to be_playing
    end
  end
end
