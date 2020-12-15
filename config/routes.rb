# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tables, only: %i[show index create] do
    resources :rounds, only: %i[show create] do
      member do
        patch :swap_cards
        patch :ready
        patch :throw_cards
        patch :take_cards
        patch :take_blind_card
      end
    end
  end

  put 'players/update'

  root to: 'tables#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
