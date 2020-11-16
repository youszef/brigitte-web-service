module GamesHelper
  def shifted_players_on_current_player(player_id, players)
    return [] unless own_player(player_id, players)
    shifted_players = players.dup
    shifted_players.index { |p| p.id == player_id }.times { shifted_players << shifted_players.shift }

    shifted_players
  end

  def own_player(player_id, players)
    players.find { |p| p.id == player_id }
  end
end
