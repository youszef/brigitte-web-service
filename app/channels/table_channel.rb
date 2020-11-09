class TableChannel < ApplicationCable::Channel
  def subscribed
    @table = Table.find_by_id(params[:id])

    stream_for @table unless @table.blank?
  end

  def unsubscribed
    return unless @table.reload

    @table.players.delete_if { |player| player['user_id'] == current_user }
    @table.save

    broadcast_to(
      @table, {}
    )
  end
end
