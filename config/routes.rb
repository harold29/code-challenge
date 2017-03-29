Rails.application.routes.draw do
  get 'sessions/new'

  get 'users/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'videos#index'

  get 'videos/show'
  get "/signup",    to: 'users#new'
  get "/signup",    to: 'users#create'
  get '/choose',    to: 'sessions#choose'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resource :users
end
