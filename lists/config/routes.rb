Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: "callbacks" }

  root to: 'welcome#home'

  resources :tags

  resources :users, only: [:show]

  resources :lists do

    resources :tasks  
  end

  get '/search', to: 'lists#search'
  post '/search', to: 'lists#search'

  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
