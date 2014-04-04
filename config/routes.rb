Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :recurrings, except: :show do
      resources :plans, except: :show
    end

    resources :reports, only: :index do
      collection do
        resources :subscriptions, only: :index
        resources :subscription_events, only: :index
      end
    end
  end

  resources :recurring_hooks, only: :none do
    post :handler, on: :collection
  end

  namespace :recurring do
    resources :plans, only: :index do
      resources :subscriptions, only: [:show, :create, :destroy, :new]
    end
  end
end
