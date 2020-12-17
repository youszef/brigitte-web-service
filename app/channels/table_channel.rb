class TableChannel < ApplicationCable::Channel
  def subscribed
    @table = Table.find_by_id(params[:id])

    stream_for @table unless @table.blank?
  end

  def unsubscribed
    @table = Table.find_by_id(params[:id])

    return unless @table
    # return remove_player_from_table if @table.rounds.empty?
    # return remove_player_from_table if @table.rounds.last.game.game_over

    unless @table.rounds.last.players.pluck('id').include?(current_user)
      remove_player_from_table
    end
  end

  def remove_player_from_table
    # TODO put this transaction in lock
    @table.players.delete_if { |player| player['id'] == current_user }
    @table.save

    broadcast_to(
      @table, { gamemaster: @table.players.first, players: @table.players }
    )
  end
end
