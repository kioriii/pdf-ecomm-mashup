Rails.application.routes.draw do
  resources :pdfs
  namespace :admin do
    resources :categories
  end
  devise_for :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"


  # TODO: This doesn't seem to be working as intended! Leaving it here for now
  # If an admin_user is authenticated, to set the root to the index in the admin controller. Called the admin_root path
  authenticated :admin_user do
    root to: "admin#index", as: :admin_root
  end

  # If a GET request is received for "admin", app is to execute index in the admin controller
  get "admin" => "admin#index"

  # this should link to the new empty pdf creation
  get "/new_empty_pdf", to: "pdfs#new_empty_pdf"

  # this should link to the new test pdf creation
  get "/new_test_pdf", to: "pdfs#new_test_pdf"

  # this is the temporary route for getting a number of pdf pages to generate
  post "/pdfnumber", to: "pdfs#new_test_pdfnumber_pdf"

  # this is the temporary route for getting a number of pdf pages to generate
  post "/pdfnumber_numbered", to: "pdfs#new_test_pdfnumber_numbered_pdf"
end
