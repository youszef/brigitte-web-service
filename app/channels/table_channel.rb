class TableChannel < ApplicationCable::Channel
  def subscribed
    @table = Table.find_by_id(params[:id])

    stream_for @table unless @table.blank?
  end

  def unsubscribed
    @table = Table.find_by_id(params[:id])
    return unless @table
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
