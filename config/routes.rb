Rails.application.routes.draw do
  devise_for :users
  get '/assignments', to: 'assignments#index'
  get 'assignments/show'
  get 'assignments/new'
  get 'assignments/create'
  get 'assignments/edit'
  get 'assignments/update'
  get 'assignments/destroy'
  get '/projects', to: 'projects#index'
  get 'projects/show'
  get 'projects/new'
  get 'projects/create'
  get 'projects/edit'
  get 'projects/update'
  get 'projects/destroy'
  get '/members', to: 'members#index'
  unauthenticated do
    root to: redirect('/users/sign_in'), as: :unauthenticated_root
  end

  authenticated :user do
    root to: redirect('/members'), as: :authenticated_root
  end
  resources :members
  resources :projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
