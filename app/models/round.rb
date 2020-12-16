# frozen_string_literal: true

class Round < ApplicationRecord
  default_scope { order('created_at ASC') }

  belongs_to :table

  attribute :game, :brigitte_game
end
