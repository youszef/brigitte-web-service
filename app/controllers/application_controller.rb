# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_player

  private

    def set_player
      cookies.encrypted[:user_id] ||= SecureRandom.uuid
      cookies.encrypted[:user_name] ||= Faker::Creature::Animal.name
    end
end
