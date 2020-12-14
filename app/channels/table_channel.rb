class TableChannel < ApplicationCable::Channel
  def subscribed
    @table = Table.find_by_id(params[:id])

    stream_for @table unless @table.blank?
  end

  def unsubscribed
    @table = Table.find_by_id(params[:id])
    return unless @table

    @table.players.delete_if { |player| player['id'] == current_user }
    @table.save

    broadcast_to(
      @table, { gamemaster: @table.players.first, players: @table.players }
    )
  end
end
