Rails.application.routes.draw do
  # get 'session_trainers/new'
  devise_for :users
  resources :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :intelligences
  resources :actions
  resources :theories
  resources :contents do
    resources :content_modules
    resources :theory_contents, only: [:create, :destroy]
  end
  resources :client_companies, path: '/companies' do
    resources :client_contacts, path: '/contacts'
  end
  resources :invoice_items, only: [:index, :show, :edit, :update]
  get 'invoices', to: 'invoice_items#invoice_index', as: 'invoices'
  post 'new_invoice_item', to: 'invoice_items#new_invoice_item', as: 'new_invoiceitem'
  post 'new_sevener_invoice', to: 'invoice_items#new_sevener_invoice', as: 'new_sevener_invoice'
  get 'estimates', to: 'invoice_items#estimate_index', as: 'estimates'
  get 'invoice_items/:id/export', to: 'invoice_items#export', as: 'invoice_item_export'
  get 'invoice_items/:id/marked', to: 'invoice_items#marked_as_paid', as: 'invoice_marked'
  post 'upload_to_sheet', to: 'invoice_items#upload_to_sheet', as: 'upload_to_sheet'
  get 'report', to: 'invoice_items#report', as: 'report'
  resources :invoice_lines, only: [:create, :edit, :update, :destroy]
  resources :trainings do
    resources :sessions do
      resources :workshops, only: [:show, :create, :edit, :update, :destroy] do
        resources :workshop_modules
      end
      resources :session_trainers, only: [:create, :destroy], path: '/trainers'
      resources :comments
    end
    resources :training_ownerships, only: [:create, :destroy], path: '/owners'
  end
  get 'trainings_week', to: 'trainings#index_week', as: "index_week"
  get 'trainings_month', to: 'trainings#index_month', as: "index_month"
  get 'session_viewer/:id', to: 'sessions#viewer', as: 'session_viewer'
  post 'workshop/:id', to: "workshops#move", as: "move_workshop"
  get 'workshop/:id', to: 'workshops#save', as: "save_workshop"
  get 'workshop_viewer/:id', to: 'workshops#viewer', as: 'workshop_viewer'
  get 'workshop_module/:id/move_up', to: "workshop_modules#move_up", as: "move_up_workshop_module"
  get 'workshop_module/:id/move_down', to: "workshop_modules#move_down", as: "move_down_workshop_module"
  get 'workshop_module_viewer/:id', to: 'workshop_modules#viewer', as: 'workshop_module_viewer'
  get 'content_module/:id/move_up', to: 'content_modules#move_up', as: 'move_up_content_module'
  get 'content_module/:id/move_down', to: 'content_modules#move_down', as: 'move_down_content_module'
end
