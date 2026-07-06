# frozen_string_literal: true

class Game < ApplicationRecord
	include AASM

	LETTER = /[a-z]/i

	validates :answer, presence: true

	before_validation :initialize_board, on: :create

	aasm column: :state do
		state :playing, initial: true
		state :won
		state :lost

		event :win do
			transitions from: :playing, to: :won
		end

		event :lose do
			transitions from: :playing, to: :lost
		end
	end

	private

	def initialize_board
		return if answer.blank?

		self.board = answer.chars.map { |character| character unless character.match?(LETTER) }
	end
end
