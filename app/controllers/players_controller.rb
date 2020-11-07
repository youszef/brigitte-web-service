class PlayersController < ApplicationController
  def update
    cookies.encrypted[:name] = params[:name]

    redirect_to tables_index_path
  end
end
