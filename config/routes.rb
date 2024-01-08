Rails.application.routes.draw do

  namespace:api do
    namespace :v1 do

      resources :loads
      resources :products
      resources :users
    end
  end

  get "home" => "home#index"

end
