Rails.application.routes.draw do

  resources :cats
  resources :cat_rental_requests, only: [:index, :create, :new, :show, :edit] do
    post 'approve', on: :member
    post 'deny', on: :member
  end

  root to: 'cats#index'
end
