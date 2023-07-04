Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :destroy, :update] do
        get 'payments', to: 'payments#user_payments', on: :collection
        get 'address', to: 'address#user_addresses', on: :collection
        get 'rides', to: 'rides#user_rides'        

        collection do
          get 'confirm_email/:token', to: 'users#confirm_email', as: 'confirm_email'          
        end
      end
      post 'auth/login', to: 'authentication#login'
      resources :payments, only: [:index, :show, :create, :destroy, :update]
      resources :address, only: [:index, :show, :create, :destroy, :update]
      resources :rides do
        collection do
          post 'start_ride'
        end
        member do           
          post 'end_ride'
        end
      end
    end
  end
end
