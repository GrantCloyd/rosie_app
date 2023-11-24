Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :topics do 
    resources :invites, only: [:new, :create], controller: 'topics/invites'
    resources :posts, controller: 'topics/posts' do 
      member do 
        post :publish, :unpublish
      end
    end
  end
  
  resources :users, only: [:new, :create]

  resources :sessions, only: [:create, :destroy, :new]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "sessions#new"
end
