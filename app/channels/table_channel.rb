class TableChannel < ApplicationCable::Channel
  def subscribed
    @table = Table.find_by_id(params[:id])

    stream_for @table unless @table.blank?
  end

  def unsubscribed
    @table = Table.find_by_id(params[:id])
    return unless @table

    @table.players.delete_if { |player| player['user_id'] == current_user }
    @table.save
    @table.active_game&.update_attributes(active: false) if @table.players.empty?

    broadcast_to(
      @table, players: @table.players
    )
  end
end
