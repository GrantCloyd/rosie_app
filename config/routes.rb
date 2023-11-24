# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :topics do
    resources :invites, only: %i[new create], controller: 'topics/invites' do
      collection do
        post :mass_add
      end
    end
    resources :posts, controller: 'topics/posts' do
      member do
        post :publish, :unpublish
      end
    end
  end

  resources :users, only: %i[new create]

  resources :sessions, only: %i[create destroy new]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'sessions#new'
end
