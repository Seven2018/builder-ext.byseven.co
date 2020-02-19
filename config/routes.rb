Rails.application.routes.draw do
  # get 'session_trainers/new'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users
  root to: 'pages#home'
  get 'survey', to: 'pages#survey', as: 'survey'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :intelligences
  resources :actions
  resources :theories
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
  get 'invoice_item/:id/copy', to: 'invoice_items#copy', as: 'copy_invoice_item'
  get 'invoice_item/:id/edit_client', to: 'invoice_items#edit_client', as: 'edit_client_invoice_item'
  get 'invoice_item/:id/credit', to: 'invoice_items#credit', as: 'credit_invoice_item'
  get 'invoices', to: 'invoice_items#invoice_index', as: 'invoices'
  post 'new_invoice_item', to: 'invoice_items#new_invoice_item', as: 'new_invoiceitem'
  post 'new_sevener_invoice', to: 'invoice_items#new_sevener_invoice', as: 'new_sevener_invoice'
  get 'estimates', to: 'invoice_items#estimate_index', as: 'estimates'
  get 'invoice_items/:id/export', to: 'invoice_items#export', as: 'invoice_item_export'
  get 'invoice_items/:id/marked_as_send', to: 'invoice_items#marked_as_send', as: 'marked_as_send_invoice_item'
  get 'invoice_items/:id/marked_as_paid', to: 'invoice_items#marked_as_paid', as: 'marked_as_paid_invoice_item'
  get 'invoice_items/:id/marked_as_reminded', to: 'invoice_items#marked_as_reminded', as: 'marked_as_reminded_invoice_item'
  get 'invoice_items/export_to_csv', to: 'invoice_items#export_to_csv', as: 'export_to_csv_invoice_items'
  post 'upload_to_sheet', to: 'invoice_items#upload_to_sheet', as: 'upload_to_sheet'
  get 'report', to: 'invoice_items#report', as: 'report'
  resources :invoice_lines, only: [:create, :edit, :update, :destroy]
  get 'invoice_line/:id/move_up', to: "invoice_lines#move_up", as: "move_up_invoice_line"
  get 'invoice_line/:id/move_down', to: "invoice_lines#move_down", as: "move_down_invoice_line"
  get 'trainings_week', to: 'trainings#index_week', as: "index_week"
  get 'trainings_month', to: 'trainings#index_month', as: "index_month"
  get 'training/:id/copy', to: 'trainings#copy', as: 'copy_training'
  resources :trainings do
    get 'session_viewer/:id', to: 'sessions#viewer', as: 'session_viewer'
    get 'session/:id/copy', to: 'sessions#copy', as: 'copy_session'
    get 'session/:id/copy_here', to: 'sessions#copy_here', as: 'copy_here_session'
    get 'session/:id/presence_sheet', to: 'sessions#presence_sheet', as: 'session_presence_sheet'
    resources :sessions, only: [:new, :show, :create, :update, :destroy] do
      post 'workshop/:id', to: "workshops#move", as: "move_workshop"
      get 'workshop/:id', to: 'workshops#save', as: "save_workshop"
      get 'workshop_viewer/:id', to: 'workshops#viewer', as: 'workshop_viewer'
      get 'workshop/:id/move_up', to: "workshops#move_up", as: "move_up_workshop"
      get 'workshop/:id/move_down', to: "workshops#move_down", as: "move_down_workshop"
      get 'workshop/:id/copy', to: "workshops#copy", as: "copy_workshop"
      resources :workshops, only: [:show, :create, :edit, :update, :destroy] do
        resources :workshop_modules
        get 'workshop_module_viewer/:id', to: 'workshop_modules#viewer', as: 'workshop_module_viewer'
        get 'workshop_module/:id/move_up', to: "workshop_modules#move_up", as: "move_up_workshop_module"
        get 'workshop_module/:id/move_down', to: "workshop_modules#move_down", as: "move_down_workshop_module"
        get 'workshop_module/:id/copy', to: 'workshop_modules#copy', as: 'copy_workshop_module'
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
  get '/redirect', to: 'session_trainers#redirect', as: 'redirect'
  get '/callback', to: 'session_trainers#callback', as: 'callback'
  get '/calendars', to: 'session_trainers#calendars', as: 'calendars'
  # devise_scope :user do
  #   get '/users/auth/linkedin/callback', to: 'users/omniauth_callbacks#linkedin', as: 'linkedin_auth'
  # end
  get '/linkedin_scrape', to: 'users#linkedin_scrape', as: 'linkedin_scrape'
  get '/linkedin_scrape_callback', to: 'users#linkedin_scrape_callback', as: 'linkedin_scrape_callback'
end
