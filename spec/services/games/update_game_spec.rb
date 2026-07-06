# frozen_string_literal: true

require "rails_helper"

RSpec.describe Games::UpdateGame do
  describe ".run" do
    it "returns the game" do
      game = create(:game)

      result = described_class.run(game: game, guess: "h")

      expect(result).to eq(game)
    end

    context "when the guessed letter is in the answer" do
      it "reveals the letter's position on the board" do
        game = create(:game, answer: "hangman")

        described_class.run(game: game, guess: "h")

        expect(game.board[game.answer.index("h")]).to eq("h")
      end

      it "reveals every occurrence of the letter" do
        game = create(:game, answer: "hangman")

        described_class.run(game: game, guess: "a")

        revealed_indices = game.answer.chars.each_index.select { |index| game.answer[index] == "a" }
        expect(game.board.values_at(*revealed_indices)).to all(eq("a"))
      end

      it "records the guess as correct" do
        game = create(:game, answer: "hangman")

        described_class.run(game: game, guess: "h")

        expect(game.guesses["h"]).to be(true)
      end

      it "does not increase the number of tries" do
        game = create(:game, answer: "hangman")

        expect { described_class.run(game: game, guess: "h") }.not_to change(game, :number_of_tries)
      end

      it "is case-insensitive" do
        game = create(:game, answer: "hangman")

        described_class.run(game: game, guess: "H")

        expect(game.board[game.answer.index("h")]).to eq("h")
      end
    end

    context "when the guessed letter is not in the answer" do
      it "does not reveal any board slot" do
        game = create(:game, answer: "hangman")

        described_class.run(game: game, guess: "z")

        expect(game.board).to all(be_nil)
      end

      it "records the guess as incorrect" do
        game = create(:game, answer: "hangman")

        described_class.run(game: game, guess: "z")

        expect(game.guesses["z"]).to be(false)
      end

      it "increases the number of tries by one" do
        game = create(:game, answer: "hangman")

        expect { described_class.run(game: game, guess: "z") }.to change(game, :number_of_tries).by(1)
      end
    end

    context "when the same letter is guessed again" do
      it "does not increase the number of tries a second time" do
        game = create(:game, answer: "hangman")
        described_class.run(game: game, guess: "z")

        expect { described_class.run(game: game, guess: "z") }.not_to change(game, :number_of_tries)
      end
    end

    context "when the final missing letter is guessed" do
      it "transitions the game to won" do
        game = create(:game, answer: "hangman")
        remaining_letters = game.answer.chars.uniq
        last_letter = remaining_letters.pop
        remaining_letters.each { |letter| described_class.run(game: game, guess: letter) }

        described_class.run(game: game, guess: last_letter)

        expect(game).to be_won
      end
    end

    context "when the maximum number of incorrect guesses is reached" do
      it "transitions the game to lost" do
        game = create(:game, answer: "hangman")
        wrong_letters = ("a".."z").to_a - game.answer.chars.uniq
        wrong_letters.first(described_class::MAX_INCORRECT_GUESSES).each do |letter|
          described_class.run(game: game, guess: letter)
        end

        expect(game).to be_lost
      end
    end

    context "when the game is already over" do
      it "does not change the board" do
        game = create(:game, answer: "hangman", state: "won")

        expect { described_class.run(game: game, guess: "h") }.not_to change(game, :board)
      end
    end

    context "with an invalid guess" do
      it "raises an error when the guess is not a single letter" do
        game = create(:game, answer: "hangman")

        expect { described_class.run(game: game, guess: "ha") }.to raise_error(ArgumentError)
      end
    end

    it "persists the changes to the database" do
      game = create(:game, answer: "hangman")

      described_class.run(game: game, guess: "h")

      expect(game.reload.guesses["h"]).to be(true)
    end
  end
end
