# config/routes.rb
Rails.application.routes.draw do
  get "landing/welcome"
  require 'sidekiq/web'
  # Monta la interfaz de Sidekiq (solo en entorno de desarrollo)
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?

  # Rutas principales para facturas (Invoices)
  resources :invoices do
    member do
      post :issue           # POST /invoices/:id/issue
      get :download_pdf     # GET /invoices/:id/download_pdf
      get :download_json    # GET /invoices/:id/download_json
    end
  end

  # Espacio de nombres para API (pensado para integración futura con DIAN)
  namespace :api do
    namespace :v1 do
      resources :invoices, only: [:index, :show, :create]
    end
  end

  # Página raíz del sistema
  #root "invoices#index"
  root "landing#welcome"
  # Namespaced audit endpoints
  namespace :audit, defaults: { format: :json } do
    post 'clients', to: 'clients#create'
  end
end
