Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_closed', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :styles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to: 'ratings#new'
  # post 'ratings', to: 'ratings#create'

  resources :ratings, only: [:index, :new, :create, :destroy]

  resource :session, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  root 'breweries#index'

  resources :places, only: [:index, :show]
  post 'places', to: 'places#search'
end
