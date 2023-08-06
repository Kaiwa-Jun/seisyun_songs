Rails.application.routes.draw do
  root 'songs#index'
  resources :users, only: [:new, :create, :edit, :update]
  resources :songs, only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      get :search
    end
  end
  resources :likes, only: [:create, :destroy]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
