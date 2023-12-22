# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :groups do 
    resources :sections, controller: 'groups/sections' do
      member do
        post :publish, :unpublish
      end
      resources :posts, controller: 'groups/sections/posts' do
        member do
          post :publish, :unpublish
        end
      end
    end
    resources :invites, except: [:show], controller: 'groups/invites' do
      member do
        post :accept, :reject
      end
      collection do
        post :mass_add
      end
    end
  end

  resources :posts, only: [] do
    resources :comments, controller: 'posts/comments', only: [:create, :destroy, :edit, :update] do
      member do 
        get :cancel
      end
    end
    resources :reactions, controller: 'posts/reactions'
    resources :images, controller: 'posts/images'
  end

  resources :sessions, only: %i[create destroy new]
  resources :users, only: %i[new create]


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  #sidekiq
  mount Sidekiq::Web => '/sidekiq'

  # Defines the root path route ("/")
  root 'sessions#new'
end
