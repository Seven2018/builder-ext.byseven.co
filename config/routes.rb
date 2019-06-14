Rails.application.routes.draw do
  get 'session_trainers/new'
  devise_for :users
  resources :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :intelligences
  resources :contents
  resources :client_companies, path: '/companies'
  resources :client_contacts, path: '/contacts'
  resources :projects do
    resources :sessions do
      resources :content_modules, only: [:show, :create, :edit, :update, :destroy], path: '/modules'
      resources :session_trainers, only: [:create, :destroy], path: '/trainers'
      resources :comments
    end
    resources :project_ownerships, only: [:create, :destroy], path: '/owner'
  end
  get 'projects_week', to: 'projects#index_week', as: "index_week"
  get 'projects_month', to: 'projects#index_month', as: "index_month"
  post 'content_module/:id', to: "content_modules#move", as: "move_mod"
  get 'content_module/:id', to: 'content_modules#save', as: "save_mod"
end
