# frozen_string_literal: true

require 'securerandom'

class TablesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:players]
  # this should normally not be skipped as this is a call made by fetch.
  # rails only checks for xhr hence skipping verification for token
  # see https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L258

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
