# frozen_string_literal: true

Player = Struct.new(:id, :name)
class ApplicationController < ActionController::Base
  before_action :set_player_from_cookie

  private

    def set_player_from_cookie
      cookies.encrypted[:user_id] ||= SecureRandom.uuid
      cookies.encrypted[:user_name] ||= Faker::Creature::Animal.name

      Current.player = Player.new(cookies.encrypted[:user_id], cookies.encrypted[:user_name])
    end
end
