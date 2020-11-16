# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tables, only: %i[show index create] do
    resources :games, only: %i[show create] do
      patch :swap_cards, on: :member
    end
  end

  put 'players/update'

  root to: 'tables#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
