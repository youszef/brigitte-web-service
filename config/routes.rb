# frozen_string_literal: true

Rails.application.routes.draw do
  get 'tables/:id', to: 'tables#show', as: :table
  get 'tables/:id/players', to: 'tables#players', as: :table_players
  get 'tables/index'
  post 'tables/create'

  resources :tables, only: %i[show index create] do
    get :players, on: :member

    resources :games, only: %i[create]
  end

  put 'players/update'

  root to: 'tables#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
