Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
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
