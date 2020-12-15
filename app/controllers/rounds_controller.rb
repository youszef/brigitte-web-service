# frozen_string_literal: true

class RoundsController < ApplicationController
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
    active_player_index = @game.active_players.index(Current.player)

    Round.transaction do
      Round.lock('FOR UPDATE')
                  .where(id: @round.id)
                  .update_all("game = jsonb_set(game, '{active_players, #{active_player_index}}', '#{@player.to_h.to_json}'::jsonb, false)")
    end

    RoundChannel.broadcast_to(@round, {})

    respond_to do |format|
      format.js { render :show, locals: { refresh_all: true } }
    end
  end

  def ready
    return if @player.ready?

    @player.ready!
    @game.play
    save_game

    RoundChannel.broadcast_to(@round, {})

    respond_to do |format|
      format.js { render :show, locals: { refresh_all: true } }
    end
  end

  def throw_cards
    thrown_cards = @player.hand.select { |c| params[:card_ids].include?(c.id) }
    success = @game.throw_cards(
      @player,
      *thrown_cards
    )
    save_game

    if success
      RoundChannel.broadcast_to(
        @round,
        { thrown_card: { image_path: ActionController::Base.helpers.image_path("cards/#{thrown_cards.last}.svg") } }
      )
    end

    respond_to do |format|
      format.js { render :show, locals: { refresh_all: true } }
    end
  end

  def take_cards
    @game.take_cards_from_pile(@player)
    save_game

    RoundChannel.broadcast_to(@round, {})

    respond_to do |format|
      format.js { render :show, locals: { refresh_all: true } }
    end
  end

  def take_blind_card
    @game.take_blind_card(@player, params[:blind_card_index].to_i)
    save_game

    RoundChannel.broadcast_to(@round, {})

    respond_to do |format|
      format.js { render :show, locals: { refresh_all: true } }
    end
  end

  def create
    table = Table.find(params[:table_id])
    if Current.player.id != table.players.first['id']
      redirect_to :show, table, alert: "Only Gamemaster #{table.players.first['name']} can start the game."
    end

    @game = Brigitte::Game.new.start_new_game(table.players, player_id_key: 'id', player_name_key: 'name')
    round = table.rounds.create(game: @game)

    TableChannel.broadcast_to(table, round_path: table_round_path(table, round))

    redirect_to table_round_path table, round
  end

  private

  def set_game
    @round = Round.find(params[:id])
    @game = @round.game
  end

  def set_player
    @player = @game.active_players.find { |p| p == Current.player }
  end

  def save_game
    @round.update(game: @game.to_h)
  end
end
