# frozen_string_literal: true

require 'securerandom'

class TablesController < ApplicationController
  def index; end

  def show
    @table = Table.find(params[:id])
    join_player
  end

  def create
    @table = Table.create(players: [{ user_id: cookies.encrypted[:user_id], user_name: cookies.encrypted[:user_name] }])

    redirect_to table_path(@table)
  end

  private

  def join_player
    return if @table.players.pluck('user_id').include?(cookies.encrypted[:user_id])

    @table.players << { user_id: cookies.encrypted[:user_id], user_name: cookies.encrypted[:user_name] }
    @table.save

    TableChannel.broadcast_to(
      "table_#{@table.id}",
      { players: @table.players }
    )
  end
end
