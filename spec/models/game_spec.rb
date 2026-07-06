# frozen_string_literal: true

require "rails_helper"

RSpec.describe Game, type: :model do
  describe "validations" do
    it "is invalid without an answer" do
      game = build(:game, answer: nil)

      expect(game).not_to be_valid
    end
  end

  describe "#initialize_board" do
    it "sets the board to an array matching the answer's length" do
      game = create(:game, answer: "hangman")

      expect(game.board.length).to eq("hangman".length)
    end

    it "sets each board slot to nil" do
      game = create(:game, answer: "hangman")

      expect(game.board).to all(be_nil)
    end

    it "reveals spaces immediately" do
      game = create(:game, answer: "open source")

      expect(game.board[game.answer.index(" ")]).to eq(" ")
    end
  end

  describe "state machine" do
    it "starts in the playing state" do
      game = create(:game)

      expect(game).to be_playing
    end

    it "transitions to won when the win event fires" do
      game = create(:game)

      game.win!

      expect(game).to be_won
    end

    it "transitions to lost when the lose event fires" do
      game = create(:game)

      game.lose!

      expect(game).to be_lost
    end
  end
end
