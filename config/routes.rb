Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :recurrings, except: :show do
      resources :plans, except: :show
    end

    resources :subscriptions, only: :index, controller: :subscription_plans
    resources :subscription_events, only: :index
  end

  resources :recurring_hooks, only: :none do
    post :handler, on: :collection
  end

  resources :plans, only: :index, controller: :plans do
    resources :subscriptions, only: [:show, :create, :destroy, :new], controller: :subscription_plans
  end
end
