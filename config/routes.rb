Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { # Rotas para login e criação de conta usando o devise.
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  namespace :admin, defaults: { format: :json } do
    namespace :v1 do
      get "home" => "home#index"
      get 'users/current', to: 'users#current'
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :loads, only: [:index, :show, :create, :update, :destroy] do
        resources :orders, only: [:index, :show, :create, :update, :destroy] do
          resources :order_products, only: [:index, :create, :show, :update, :destroy]
          resources :sorted_order_products, only: [:index]
        end
      end
    end
  end
end