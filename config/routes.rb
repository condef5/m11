Rails.application.routes.draw do
  root 'home#index'

  resources :players
  resources :random_teams, only: %i[index create]
end
