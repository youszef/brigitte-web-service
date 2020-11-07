# frozen_string_literal: true

Rails.application.routes.draw do
  get 'tables/:id', to: 'tables#show', as: 'table'
  get 'tables/index'
  post 'tables/create'

  get 'games/show'
  get 'games/new'
  post 'games/create'

  put 'players/update'

  root to: 'tables#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
