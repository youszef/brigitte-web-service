# frozen_string_literal: true

class BrigitteGame < ApplicationRecord
  belongs_to :table

  def game_object
    @game_object ||= Brigitte::Game.from_h(game.deep_symbolize_keys)
  end
end
