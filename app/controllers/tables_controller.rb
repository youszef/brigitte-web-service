# frozen_string_literal: true

class TablesController < ApplicationController
  before_action :set_table, only: [:show]

  def index; end

  def show
    # TODO query in SQL if table has pending games instead
    if @table.players.count > 3 || @table.rounds.any? { |r| !r.game.game_over }
      redirect_to :root, table, notice: 'Sorry. Table is full or a game has already started. Try another one.'
    end

    join_player
  end

  def create
    redirect_to table_path(Table.create)
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
