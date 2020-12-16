# frozen_string_literal: true

class Table < ApplicationRecord
  default_scope { order('created_at ASC') }

  has_many :rounds, -> { order 'created_at ASC' }
end
