require 'brigitte'

class GamesController < ApplicationController
  def create
    table = Table.find(params[:table_id])

    @game = Brigitte::Game.new.start_new_game(table.players, player_id_key: 'user_id', player_name_key: 'user_name')
    table.brigitte_games.create(game: @game.to_h)

    respond_to do |format|
      format.js { render :show }
    end
  end
end
