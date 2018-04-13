Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :recurrings, except: :show do
      resources :plans, except: :show
    end

    resources :subscription_plans, only: :index
    resources :subscription_events, only: :index
  end

  resources :recurring_hooks, only: :none do
    post :handler, on: :collection
  end

  resources :plans, only: :index, controller: :plans do
    resources :subscription_plans, only: [:show, :create, :destroy, :new]
  end
end
