Rails.application.routes.draw do
  root 'songs#index'
  resources :users, only: [:new, :create, :edit, :update]
  resources :songs, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :likes, only: [:create, :destroy]
end
