Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace:api do
    namespace :v1 do

      resources :loads
      resources :products
      resources :users
    end
  end
  get "home" => "home#index"
end