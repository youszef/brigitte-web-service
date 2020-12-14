module GamesHelper
  def shifted_players_on_current_player(current_player, players)
    return [] unless current_player

    Rails.logger.debug(current_player)
    shifted_players = players.dup
    Rails.logger.debug(shifted_players)
    shifted_players.index(current_player).times { shifted_players << shifted_players.shift }

    shifted_players.insert(1, nil) if shifted_players.count == 2

    shifted_players
  end

  def last_cards_with_same_value(cards)
    same_cards = []
    cards.reverse_each do |card|
      break if same_cards.last && (same_cards.last.weight != card.weight)

      same_cards << card
    end

    same_cards.reverse!
  end
end
