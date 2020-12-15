class RoundChannel < ApplicationCable::Channel
  def subscribed
    @round = Round.find_by_id(params[:id])

    stream_for @round unless @round.blank?
  end

  def unsubscribed
    @round = Round.find_by_id(params[:id])
    return unless @round

    # TODO notify other players start count down and redirect back to table and deactivate game if player doesn't join in time
    broadcast_to(
      @round, disconnected_player_id: current_user
    )
  end
end
