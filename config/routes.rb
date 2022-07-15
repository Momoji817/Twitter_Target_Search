Rails.application.routes.draw do
  root 'static_pages#top'
  get '/terms', to: 'static_pages#terms'
  get '/privacy', to: 'static_pages#privacy'
  get '/info', to: 'static_pages#info'
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: 'auth_at_provider'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[show destroy]

  get 'following_candidates', to: 'following_candidates#index'
  post 'following_candidates/following', to: 'following_candidates#following'
end
