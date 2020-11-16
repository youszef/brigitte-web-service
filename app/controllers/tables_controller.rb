# frozen_string_literal: true

require 'securerandom'

class TablesController < ApplicationController
  before_action :set_table

  def index; end

  def show
    join_player
  end

  def create
    @table = Table.create(players: [{ user_id: cookies.encrypted[:user_id], user_name: cookies.encrypted[:user_name] }])

    redirect_to table_path(@table)
  end

  private

  def set_table
    @table = Table.find_by_id(params[:id])
  end

  def join_player
    return if @table.players.pluck('user_id').include?(cookies.encrypted[:user_id])

    @table.players << { user_id: cookies.encrypted[:user_id], user_name: cookies.encrypted[:user_name] }
    @table.save

    TableChannel.broadcast_to(@table, players: @table.players)
  end
end
