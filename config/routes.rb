Rails.application.routes.draw do
  root 'home#index'

  resources :players
  resources :random_teams, only: %i[index create]

  get 'auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/auth/google_oauth2', as: :sign_in
  get '/sign_out', to: 'sessions#destroy', as: :sign_out
end
