Rails.application.routes.draw do
  resources :beers
  resources :breweries
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'ratings', to: 'ratings#index'
  get 'ratings/new', to: 'ratings#new'

  root 'breweries#index'
  # get '/kaikki_bisset', to: 'beers#index'
end
