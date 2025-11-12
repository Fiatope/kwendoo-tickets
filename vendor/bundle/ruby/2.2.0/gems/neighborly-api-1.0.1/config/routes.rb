Neighborly::Api::Engine.routes.draw do
  scope module: :v1,
        constraints: Neighborly::Api::ApiConstraint.new(revision: 1, default: true),
        defaults: { format: :json } do

    resources :projects do
      member do
        put :approve
        put :launch
        put :reject
        put :push_to_draft
      end
    end

    resources :contributions, only: %i(index show update destroy) do
      member do
        put :confirm
        put :pendent
        put :refund
        put :hide
        put :cancel
      end
    end

    resources :rewards, only: %i(show)
    resources :tags
    resources :press_assets
    resources :users, only: %i(index show)

    resources :channels do
      resources :members, only: %i(index create destroy), controller: 'channels/members'

      member do
        put :push_to_draft
        put :push_to_online
      end
    end

    post   'sessions',     to: 'sessions#create'
    delete 'sessions',     to: 'sessions#destroy'
  end
end
