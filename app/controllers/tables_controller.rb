# frozen_string_literal: true

class TablesController < ApplicationController
  before_action :set_table, only: [:show, :join]

  def index; end

  def show
    return unless @table.rounds.last
    return if @table.rounds.last.game.game_over

    redirect_to :root, notice: "Sorry. You're too late. Game has already been started. Try another one."
  end

  def join
    # TODO query in SQL if table has pending games instead
    if @table.players.count > 3 || @table.rounds.any? { |r| !r.game.game_over }
      redirect_to :root, notice: 'Sorry. Table is full or a game has already been started. Try another one.'

      return
    end

    join_player

    redirect_to table_path(@table)
  end

  def create
    @table = Table.create
    join_player

    redirect_to table_path(@table)
  end

  private

  def set_table
    @table = Table.find_by_id(params[:id])
  end

  def join_player
    return if @table.players&.pluck('id')&.include?(Current.player.id)

    @table.players << Current.player.to_h
    @table.save

    TableChannel.broadcast_to(@table, { gamemaster: @table.players.first, players: @table.players })
  end
end
