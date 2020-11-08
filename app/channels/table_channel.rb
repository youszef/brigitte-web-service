class TableChannel < ApplicationCable::Channel
  def subscribed
    @table = Table.find_by_id(params[:id])

    stream_for @table unless @table.blank?
  end

  def unsubscribed
    return unless @table

    Rails.logger.debug("unsubscribed for user #{current_user}")
    result = @table.players.delete_if { |player| player['user_id'] == current_user }
    Rails.logger.debug("deleted players: #{result}")
    @table.save

    broadcast_to(
      @table, {}
    )
  end
end
