# frozen_string_literal: true

module Games
  class CreateGame
    include Command

    PHRASES = [
      "the quick brown fox",
      "hangman is fun",
      "ruby on rails",
      "state machine",
      "test driven development",
      "open source software",
      "continuous integration",
      "object oriented programming",
      "domain specific language",
      "convention over configuration"
    ].freeze

    def call
      Game.create!(answer: answer)
    end

    private

    def answer
      @answer ||= PHRASES.sample
    end
  end
end
