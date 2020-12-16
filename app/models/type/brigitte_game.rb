# frozen_string_literal: true

module Type
  class BrigitteGame < ActiveRecord::Type::Json
    def cast(value)
      value.to_h
    end

    def deserialize(value)
      hash = super(value)
      return unless hash

      Brigitte::Game.from_h(hash.deep_symbolize_keys)
    end
  end
end
