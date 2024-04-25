Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { 
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  namespace :admin, defaults: { format: :json } do
    namespace :v1 do
      get "home", to: "home#index"
      get 'users/current', to: 'users#current'
      
      resources :users, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'count'
        end
      end
      
      resources :products, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'count'
        end
      end

      resources :loads, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'count'
        end
        resources :orders, only: [:index, :show, :create, :update, :destroy] do
          resources :order_products, only: [:index, :create, :show, :update, :destroy]
          resources :sorted_order_products, only: [:index] do
            get :show_sorted_products, on: :collection
          end
        end
      end
      
      post 'sorted_order_products/sort_all', to: 'sorted_order_products#sort_all'
    end
  end
end