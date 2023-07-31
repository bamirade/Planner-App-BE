Rails.application.routes.draw do
  resources :tasks
  resources :categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :categories do
    resources :tasks
  end

  resources :users, only: [:show, :update, :destroy] do
    member do
      patch '/update_password', to: 'users#update_password'
    end
  end

  post '/signup', to: 'users#create'
  post '/login', to: 'users#login'

end
