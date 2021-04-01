Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # USERS
  resources :users

  # TRAININGS
  resources :trainings do
    get 'session_viewer/:id', to: 'sessions#viewer', as: 'session_viewer'
    get 'session/:id/copy', to: 'sessions#copy', as: 'copy_session'
    get 'session/:id/copy_form', to: 'sessions#copy_form', as: 'copy_form_session'
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
    end
    get 'session_trainers/create_all', to: 'session_trainers#create_all', as: 'create_all_session_trainers'
    resources :training_ownerships, only: [:create, :destroy]
    post 'new_writer', to: 'training_ownerships#new_writer', as: 'new_writer'
    resources :forms, only: [:index, :show, :create, :update, :destroy]
  end
  get 'trainings_completed', to: 'trainings#index_completed', as: 'index_completed'
  get 'trainings_upcoming', to: 'trainings#index_upcoming', as: 'index_upcoming'
  get 'trainings_week', to: 'trainings#index_week', as: 'index_week'
  get 'trainings_month', to: 'trainings#index_month', as: 'index_month'
  get 'trainings/:id/copy', to: 'trainings#copy', as: 'copy_training'
  get 'trainings/:id/update_calendar', to: 'session_trainers#update_calendar', as: 'update_calendar'
  get 'trainings/:id/trainer_notification_email', to: 'trainings#trainer_notification_email', as: 'trainer_notification_email'
  get 'trainings/:id/trainer_session_reminder', to: 'trainings#trainer_reminder_email', as: 'trainer_reminder_email'
  get 'show_session_content', to: 'trainings#show_session_content', as: 'show_session_content'

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

  # TRAINERS
  get '/redirect', to: 'session_trainers#redirect', as: 'redirect'
  get '/callback', to: 'session_trainers#callback', as: 'callback'
  get '/calendars', to: 'session_trainers#calendars', as: 'calendars'
  get '/remove_session_trainers', to: 'session_trainers#remove_session_trainers', as: 'remove_session_trainers'
  get '/remove_training_trainers', to: 'session_trainers#remove_training_trainers', as: 'remove_training_trainers'
end
