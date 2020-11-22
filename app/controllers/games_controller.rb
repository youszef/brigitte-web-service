require 'brigitte'

class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:show]
  # this should normally not be skipped as this is a call made by fetch.
  # rails only checks for xhr hence skipping verification for token
  # see https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L258

  before_action :set_game, except: [:create]
  before_action :set_player, except: %i[show create]

  def show
    respond_to do |format|
      format.html
      format.js { render :show }
    end
  end

  def swap_cards
    hand_card = @player.hand.find { |c| c.id == params[:from_card_id] }
    visible_table_card = @player.visible_cards.find { |c| c.id == params[:to_card_id] }

    @player.swap(hand_card, visible_table_card)

    save_game
    GameChannel.broadcast_to(@brigitte_game, {})

    respond_to do |format|
      format.js { render :show }
    end
  end

  def ready
    return if @player.ready?

    @player.ready!
    @game.play
    save_game

    GameChannel.broadcast_to(@brigitte_game, {})

    respond_to do |format|
      format.js { render :show }
    end
  end

  def throw_cards
    success = @game.throw_cards(
      @player,
      *@player.hand.select { |c| params[:card_ids].include?(c.id) }
    )
    save_game

    GameChannel.broadcast_to(@brigitte_game, {}) if success

    respond_to do |format|
      format.js { render :show }
    end
  end

  def take_cards
    @game.take_cards_from_pot(@player)
    save_game

    GameChannel.broadcast_to(@brigitte_game, {})

    respond_to do |format|
      format.js { render :show }
    end
  end

  def take_hidden_card
    @game.take_hidden_card(@player, params[:hidden_card_index].to_i)
    save_game

    GameChannel.broadcast_to(@brigitte_game, {})

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

  private

  def set_game
    @brigitte_game = BrigitteGame.find(params[:id])
    @game = @brigitte_game.game_object
  end

  def set_player
    @player = @game.active_players.find { |p| p == Current.player }
  end

    # TODO save only particular particular key value pair. Try to use jsonb_set
  def save_game
    @brigitte_game.update_attributes(game: @game.to_h)
  end
end
