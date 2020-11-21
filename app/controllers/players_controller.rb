class PlayersController < ApplicationController
  def update
    Current.player.name = cookies.encrypted[:name] = params[:name]

    redirect_to tables_index_path
  end
end
