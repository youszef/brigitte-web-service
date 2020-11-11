# frozen_string_literal: true

class Table < ApplicationRecord
  has_many :brigitte_games

  def active_game
    brigitte_games.where(active: true).last
  end
end
