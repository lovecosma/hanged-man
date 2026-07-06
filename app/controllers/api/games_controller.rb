module Api
	class GamesController < ApplicationController
		def create
			game = Games::CreateGame.run

			render json: game, status: :created
		end
		
		def update
			game = Game.find(params[:id])
			Games::UpdateGame.run(game: game, guess: game_params[:guess])

			render json: game
		end
		
		
		def game_params
			params.require(:game).permit(:guess)
		end
	end
end
