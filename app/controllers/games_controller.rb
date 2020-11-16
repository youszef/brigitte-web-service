require 'brigitte'

class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:show]
  # this should normally not be skipped as this is a call made by fetch.
  # rails only checks for xhr hence skipping verification for token
  # see https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L258

  def show
    brigitte_game = BrigitteGame.find(params[:id])
    @game = brigitte_game.game_object

    respond_to do |format|
      format.html
      format.js { render :show, render_only_cards_on_table: true }
    end
  end

  def swap_cards
    brigitte_game = BrigitteGame.find(params[:id])
    Rails.logger.debug(params)
    @game = brigitte_game.game_object
    player_id = cookies.encrypted[:user_id]
    player = @game.active_players.find { |p| p.id == player_id }
    hand_card = player.hand.find { |c| c.id == params[:from_card_id] }
    visible_table_card = player.visible_cards.find { |c| c.id == params[:to_card_id] }

    player.swap(hand_card, visible_table_card)

    brigitte_game.update_attributes(game: @game.to_h)
    GameChannel.broadcast_to(brigitte_game, table_card_changed: true)

    respond_to do |format|
      format.js { render :show }
    end
  end

  def create
    table = Table.find(params[:table_id])

    @game = Brigitte::Game.new.start_new_game(table.players, player_id_key: 'user_id', player_name_key: 'user_name')
    brigitte_game = table.brigitte_games.create(game: @game.to_h)

    TableChannel.broadcast_to(table, game_path: table_game_path(table, brigitte_game))

    redirect_to table_game_path table, brigitte_game
  end
end
