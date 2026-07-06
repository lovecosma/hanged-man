# frozen_string_literal: true

module Games
  class UpdateGame
    include Command

    MAX_INCORRECT_GUESSES = 6
    GUESS_FORMAT = /\A#{Game::LETTER}\z/

    option :game
    option :guess, proc { |value| value.to_s.downcase }

    def call
      raise ArgumentError, "guess must be a single letter" unless guess.match?(GUESS_FORMAT)

      game.with_lock do
        next if !game.playing? || already_guessed?

        record_guess
        apply_outcome
        game.save!
      end

      game
    end

    private

    def already_guessed?
      game.guesses.key?(guess)
    end

    def correct?
      return @correct if defined?(@correct)

      @correct = downcased_answer.include?(guess)
    end

    def downcased_answer
      @downcased_answer ||= game.answer.downcase
    end

    def record_guess
      game.guesses[guess] = correct?
    end

    def apply_outcome
      if correct?
        reveal_letter
        game.win! if board_complete?
      else
        game.number_of_tries += 1
        game.lose! if game.number_of_tries >= MAX_INCORRECT_GUESSES
      end
    end

    def reveal_letter
      downcased_answer.chars.each_with_index do |letter, index|
        game.board[index] = guess if letter == guess
      end
    end

    def board_complete?
      game.board.none?(&:nil?)
    end
  end
end
