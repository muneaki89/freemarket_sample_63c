Rails.application.routes.draw do
  devise_for :users
  root "tops#index"
  resources :products, only: [:new, :create]
end
