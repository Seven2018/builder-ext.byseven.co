Rails.application.routes.draw do
  # get 'session_trainers/new'
  devise_for :users
  resources :users
  get 'users_booklet', to: 'users#index_booklet', as: 'booklet_users'
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :intelligences
  resources :actions
  resources :theories
  resources :merchandises
  get 'index_request', to: 'merchandises#index_request', as: 'merchandises_index_request'
  resources :requests, only: [:create, :destroy]
  resources :bookings, only: [:index, :show, :create, :destroy]
  get 'booking/:id/transform', to: 'bookings#transform', as: 'transform_booking'
  resources :contents, only: [:index, :show, :new, :create, :update, :destroy] do
    resources :content_modules, only: [:show, :new, :create, :edit, :update, :destroy]
      get 'content_module/:id/move_up', to: 'content_modules#move_up', as: 'move_up_content_module'
      get 'content_module/:id/move_down', to: 'content_modules#move_down', as: 'move_down_content_module'
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
  # post 'upload_to_sheet', to: 'invoice_items#upload_to_sheet', as: 'upload_to_sheet'
  get 'report', to: 'invoice_items#report', as: 'report'
  resources :invoice_lines, only: [:create, :edit, :update, :destroy]
  get 'invoice_line/:id/move_up', to: "invoice_lines#move_up", as: "move_up_invoice_line"
  get 'invoice_line/:id/move_down', to: "invoice_lines#move_down", as: "move_down_invoice_line"
  get 'trainings_week', to: 'trainings#index_week', as: "index_week"
  get 'trainings_month', to: 'trainings#index_month', as: "index_month"
  get 'trainings_booklet', to: 'trainings#index_booklet', as: 'booklet_trainings'
  resources :trainings do
    get 'session_viewer/:id', to: 'sessions#viewer', as: 'session_viewer'
    resources :sessions, only: [:new, :show, :create, :update, :destroy] do
      post 'workshop/:id', to: "workshops#move", as: "move_workshop"
      get 'workshop/:id', to: 'workshops#save', as: "save_workshop"
      get 'workshop_viewer/:id', to: 'workshops#viewer', as: 'workshop_viewer'
      get 'workshop/:id/move_up', to: "workshops#move_up", as: "move_up_workshop"
      get 'workshop/:id/move_down', to: "workshops#move_down", as: "move_down_workshop"
      resources :workshops, only: [:show, :create, :edit, :update, :destroy] do
        resources :workshop_modules
        get 'workshop_module_viewer/:id', to: 'workshop_modules#viewer', as: 'workshop_module_viewer'
        get 'workshop_module/:id/move_up', to: "workshop_modules#move_up", as: "move_up_workshop_module"
        get 'workshop_module/:id/move_down', to: "workshop_modules#move_down", as: "move_down_workshop_module"
        resources :theory_workshops, only: [:create, :destroy]
      end
      resources :session_trainers, only: [:create, :destroy]
      resources :session_attendees, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :training_ownerships, only: [:create, :destroy]
    resources :forms, only: [:index, :show, :create, :update, :destroy]
  end
  resources :attendees, only: [:new, :create]
  post 'attendees/import', to: 'attendees#import', as: 'import_attendees'
  get 'training/:training_id/session/:id/attendees/export.csv', to: 'attendees#export', as: 'export_attendees'
  resources :session_forms, only: [:create, :destroy]
end
