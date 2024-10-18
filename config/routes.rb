Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#show"

  # Authentication routes
  resource :registrations, only: [ :new, :create ]
  resource :sessions, only: [ :new, :create, :destroy ]
  resource :passwords, only: [ :new, :create, :edit, :update ]

  # User routes
  resource :dashboards, only: :show
  resource :accounts, only: [ :show, :update ] do
    member do
      patch :change_password
    end
  end
end
