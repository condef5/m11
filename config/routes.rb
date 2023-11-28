Rails.application.routes.draw do
  resources :game_days
  root 'home#index'

  namespace :players do
    resources :autocompletes, only: :index
  end

  resources :players
  resources :random_teams, only: %i[index create]
  resource :onboarding, only: %i[show update]

  get 'auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/auth/google_oauth2', as: :sign_in
  get '/sign_out', to: 'sessions#destroy', as: :sign_out
end
