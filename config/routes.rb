Rails.application.routes.draw do
  # get 'session_trainers/new'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # PAGES
  root to: 'pages#home'
  get 'survey', to: 'pages#survey', as: 'survey'
  get 'numbers_activity', to: 'pages#numbers_activity', as: 'numbers_activity'
  get 'numbers_sales', to: 'pages#numbers_sales', as: 'numbers_sales'
  get 'dashboard_sevener', to: 'pages#dashboard_sevener', as: 'dashboard_sevener'
  get 'overlord', to: 'pages#overlord', as: 'overlord'
  get 'contact_form', to: 'pages#contact_form', as: 'contact_form'
  get 'contact_form_seven_x_bam', to: 'pages#contact_form_seven_x_bam', as: 'contact_form_seven_x_bam'
  get 'inscriptions_kea_partners_c', to: 'pages#kea_partners_c', as: 'kea_partners_c'
  get 'inscriptions_kea_partners_m', to: 'pages#kea_partners_m', as: 'kea_partners_m'
  get 'inscriptions_kea_partners_d', to: 'pages#kea_partners_d', as: 'kea_partners_d'
  get 'inscriptions_kea_partners_thanks', to: 'pages#kea_partners_thanks', as: 'kea_partners_thanks'

  # USERS
  resources :users

  # ACTIONS
  resources :actions

  # THEORIES
  resources :theories

  # CONTENTS
  resources :contents, only: [:index, :show, :new, :create, :update, :destroy] do
    resources :content_modules, only: [:show, :new, :create, :edit, :update, :destroy]
      get 'content_module/:id/move_up', to: 'content_modules#move_up', as: 'move_up_content_module'
      get 'content_module/:id/move_down', to: 'content_modules#move_down', as: 'move_down_content_module'
    resources :theory_contents, only: [:create, :destroy]
  end

  # CLIENT COMPANIES
  resources :client_companies, path: '/companies' do
    resources :client_contacts, path: '/contacts'
    get 'new_attendees', to: 'client_companies#new_attendees', as: 'new_attendees'
    get 'create_attendees', to: 'client_companies#create_attendees', as: 'create_attendees'
  end

  # INVOICE ITEMS
  resources :invoice_items, only: [:index, :show, :edit, :update, :destroy]
  get 'invoice_item/:id/copy', to: 'invoice_items#copy', as: 'copy_invoice_item'
  get 'invoice_item/:id/copy_here', to: 'invoice_items#copy_here', as: 'copy_here_invoice_item'
  get 'invoice_item/:id/edit_client', to: 'invoice_items#edit_client', as: 'edit_client_invoice_item'
  get 'invoice_item/:id/credit', to: 'invoice_items#credit', as: 'credit_invoice_item'
  get 'invoices', to: 'invoice_items#invoice_index', as: 'invoices'
  post 'new_invoice_item', to: 'invoice_items#new_invoice_item', as: 'new_invoiceitem'
  post 'new_sevener_invoice', to: 'invoice_items#new_sevener_invoice', as: 'new_sevener_invoice'
  post 'new_estimate', to: 'invoice_items#new_estimate', as: 'new_estimate'
  get 'estimates', to: 'invoice_items#estimate_index', as: 'estimates'
  get 'invoice_items/:id/export', to: 'invoice_items#export', as: 'invoice_item_export'
  get 'invoice_items/:id/marked_as_send', to: 'invoice_items#marked_as_send', as: 'marked_as_send_invoice_item'
  get 'invoice_items/:id/marked_as_paid', to: 'invoice_items#marked_as_paid', as: 'marked_as_paid_invoice_item'
  get 'invoice_items/:id/marked_as_reminded', to: 'invoice_items#marked_as_reminded', as: 'marked_as_reminded_invoice_item'
  get 'invoice_items/export_to_csv', to: 'invoice_items#export_to_csv', as: 'export_to_csv_invoice_items'
  post 'redirect_upload_to_drive', to: 'invoice_items#redirect_upload_to_drive', as: 'redirect_upload_to_drive'
  post 'upload_to_drive', to: 'invoice_items#upload_to_drive', as: 'upload_to_drive'
  post 'upload_to_sheet', to: 'invoice_items#upload_to_sheet', as: 'upload_to_sheet'
  get 'report', to: 'invoice_items#report', as: 'report'
  resources :invoice_lines, only: [:create, :edit, :update, :destroy]
  get 'invoice_line/:id/move_up', to: 'invoice_lines#move_up', as: 'move_up_invoice_line'
  get 'invoice_line/:id/move_down', to: 'invoice_lines#move_down', as: 'move_down_invoice_line'

  # TRAININGS
  resources :trainings do
    get 'session_viewer/:id', to: 'sessions#viewer', as: 'session_viewer'
    get 'session/:id/copy', to: 'sessions#copy', as: 'copy_session'
    get 'session/:id/copy_here', to: 'sessions#copy_here', as: 'copy_here_session'
    get 'session/:id/copy_form', to: 'sessions#copy_form', as: 'copy_form_session'
    get 'session/:id/presence_sheet', to: 'sessions#presence_sheet', as: 'session_presence_sheet'
    resources :sessions, only: [:new, :show, :create, :update, :destroy] do
      post 'workshop/:id', to: 'workshops#move', as: 'move_workshop'
      get 'workshop/:id', to: 'workshops#save', as: 'save_workshop'
      get 'workshop_viewer/:id', to: 'workshops#viewer', as: 'workshop_viewer'
      get 'workshop/:id/move_up', to: 'workshops#move_up', as: 'move_up_workshop'
      get 'workshop/:id/move_down', to: 'workshops#move_down', as: 'move_down_workshop'
      get 'workshop/:id/copy_form', to: 'workshops#copy_form', as: 'copy_form_workshop'
      get 'workshop/:id/copy', to: 'workshops#copy', as: 'copy_workshop'
      resources :workshops, only: [:show, :create, :edit, :update, :destroy] do
        resources :workshop_modules
        get 'workshop_module_viewer/:id', to: 'workshop_modules#viewer', as: 'workshop_module_viewer'
        get 'workshop_module/:id/move_up', to: 'workshop_modules#move_up', as: 'move_up_workshop_module'
        get 'workshop_module/:id/move_down', to: 'workshop_modules#move_down', as: 'move_down_workshop_module'
        get 'workshop_module/:id/copy_form', to: 'workshop_modules#copy_form', as: 'copy_form_workshop_module'
        get 'workshop_module/:id/copy', to: 'workshop_modules#copy', as: 'copy_workshop_module'
        resources :theory_workshops, only: [:create, :destroy]
      end
      resources :session_trainers, only: [:create, :destroy]
      resources :session_attendees, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    get 'session_trainers/create_all', to: 'session_trainers#create_all', as: 'create_all_session_trainers'
    resources :training_ownerships, only: [:create, :destroy]
    post 'new_writer', to: 'training_ownerships#new_writer', as: 'new_writer'
    resources :forms, only: [:index, :show, :create, :update, :destroy]
  end
  get 'trainings_completed', to: 'trainings#index_completed', as: 'index_completed'
  get 'trainings_week', to: 'trainings#index_week', as: 'index_week'
  get 'trainings_month', to: 'trainings#index_month', as: 'index_month'
  get 'trainings/:id/copy', to: 'trainings#copy', as: 'copy_training'
  get 'trainings/:id/sevener_billing', to: 'trainings#sevener_billing', as: 'sevener_billing'
  get 'training/redirect_docusign', to: 'trainings#redirect_docusign', as: 'redirect_docusign'

  # ATTENDEES
  resources :attendees, only: [:index, :show, :new, :create]
  get 'attendees/template_csv', to: 'attendees#template_csv', as: 'template_csv_attendees'
  post 'attendees/import', to: 'attendees#import', as: 'import_attendees'
  get 'training/:training_id/session/:id/attendees/export.csv', to: 'attendees#export', as: 'export_attendees'
  get 'attendee/new_kea_partners', to: 'attendees#new_kea_partners', as: 'new_kea_partners_attendee'
  post 'attendee/create_kea_partners', to: 'attendees#create_kea_partners', as: 'create_kea_partners_attendee'
  post 'new_session_attendee/kea_partners', to: 'session_attendees#create_kea_partners', as: 'new_kea_partners_session_attendee'
  delete 'delete_session_attendee/kea_partners', to: 'session_attendees#destroy_kea_partners', as: 'destroy_kea_partners_session_attendee'
  get 'test', to: 'session_attendees#test', as: 'test_session_attendee'

  # SESSION ATTENDEES
  post 'session/:id/session_attendees/link_attendees', to: 'session_attendees#link_attendees', as: 'link_attendees'
  post 'training/:id/session_attendees/link_attendees', to: 'session_attendees#link_attendees_to_training', as: 'link_attendees_to_training'

  # ATTENDEES INTERESTS
  post 'new_attendee_interest', to: 'attendee_interests#create', as: 'new_attendee_interest'
  delete 'delete_attendee_interest', to: 'attendee_interests#destroy', as: 'destroy_attendee_interest'

  # FORMS
  resources :session_forms, only: [:create, :destroy]

  # TRAINERS
  get '/redirect', to: 'session_trainers#redirect', as: 'redirect'
  get '/callback', to: 'session_trainers#callback', as: 'callback'
  get '/calendars', to: 'session_trainers#calendars', as: 'calendars'
  get '/remove_session_trainers', to: 'session_trainers#remove_session_trainers', as: 'remove_session_trainers'
  get '/remove_training_trainers', to: 'session_trainers#remove_training_trainers', as: 'remove_training_trainers'

  # LINKEDIN
  get '/linkedin_scrape', to: 'users#linkedin_scrape', as: 'linkedin_scrape'
  get '/linkedin_scrape_callback', to: 'users#linkedin_scrape_callback', as: 'linkedin_scrape_callback'
  # devise_scope :user do
  #   get '/users/auth/linkedin/callback', to: 'users/omniauth_callbacks#linkedin', as: 'linkedin_auth'
  # end
end
