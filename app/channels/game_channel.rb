class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = BrigitteGame.find_by_id(params[:id])

    stream_for @game unless @game.blank?
  end

  def unsubscribed
    return unless @game&.reload

    # notify other players start count down and redirect back to table and deactivate game if player doesn't join in time
    broadcast_to(
      @game, disconnected_player_id: current_user
    )
  end
end
