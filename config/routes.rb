Rails.application.routes.draw do
  get 'session_trainers/new'
  devise_for :users
  resources :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :intelligences
  resources :contents
  resources :client_companies
  resources :client_contacts
  resources :projects do
    resources :sessions do
      resources :content_modules, only: [:show, :create, :edit, :update, :destroy]
      resources :session_trainers, only: [:create, :destroy]
    end
    resources :project_ownerships, only: [:create, :destroy]
  end
  post 'content_module/:id', to: "content_modules#move", as: "move_mod"
end
