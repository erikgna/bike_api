Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :destroy, :update] do
        get 'payments', to: 'payments#user_payments'
      end
      post 'auth/login', to: 'authentication#login'
      resources :payments, only: [:index, :show, :create, :destroy, :update]
    end
  end
end
