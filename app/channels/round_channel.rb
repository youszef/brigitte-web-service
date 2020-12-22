class RoundChannel < ApplicationCable::Channel
  def subscribed
    @round = Round.find_by_id(params[:id])

    stream_for @round unless @round.blank?
  end

  def unsubscribed
    @round = Round.find_by_id(params[:id])
    return unless @round

    # TODO put this transaction in lock
    @round.table.players.delete_if { |player| player['id'] == current_user }
    @round.table.save

    # TODO notify other players start count down and redirect back to table and deactivate game if player doesn't join in time
    broadcast_to(
      @round, disconnected_player: current_user
    )
  end
end
