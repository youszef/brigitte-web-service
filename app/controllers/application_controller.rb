# frozen_string_literal: true

Player = Struct.new(:id, :name)
class ApplicationController < ActionController::Base
  before_action :set_player_from_cookie

  private

    def set_player_from_cookie
      cookies.encrypted[:id] ||= SecureRandom.uuid
      cookies.encrypted[:name] ||= Faker::Creature::Animal.name

      Current.player = Player.new(cookies.encrypted[:id], cookies.encrypted[:name])
    end
end
