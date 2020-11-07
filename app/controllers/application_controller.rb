# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :set_player

  def set_player
    cookies.encrypted[:user_id] ||= SecureRandom.uuid
    cookies.encrypted[:user_name] ||= Faker::Creature::Animal.name
  end
end
