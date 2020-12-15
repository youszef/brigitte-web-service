# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :table

  attribute :game, :brigitte_game
end
