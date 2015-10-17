Rails.application.routes.draw do

  # Root is the unauthenticated path
  root 'sessions#unauth'

  # Sessions URL
  get 'sessions/unauth', as: :login
  post 'sessions/login', as: :signin
  delete 'sessions/logout', as: :logout
  post 'users/scrape', as: :scrape # Initiaties commands to start scraping articles form web

  get '/interests', to: 'articles#my_interests', as: 'interests' # Shows articles that have been tagged with interests


  resources :users, only: [:create, :new, :update, :destroy, :edit]
  resources :articles, only: [:destroy, :show, :index]


end
