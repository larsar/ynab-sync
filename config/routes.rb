Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    get 'setup', to: 'users#show'
    get 'ynab_token', to: 'users#edit_ynab_access_token'
    post 'ynab_token', to: 'users#update_access_token'


    resources :sources do
      resources :collections
    end

    resources :budgets do
      post 'enable', to: 'budgets#enable'
      post 'disable', to: 'budgets#disable'
      resources 'accounts' do
        post 'unlink', to: 'accounts#unlink'
        post 'manual_sync', to: 'accounts#manual_sync'
        post 'auto_sync', to: 'accounts#auto_sync'
      end
    end

    resources :transactions, only: [:clear, :unclear] do
      post 'clear', to: 'transactions#clear'
      post 'unclear', to: 'transactions#unclear'
    end
    post 'transactions/import/:item_id', to: 'transactions#import', as: :transactions_import_item

    post 'sync', to: 'dashboard#sync'

    get 'sbanken/new', to: 'sources#new', type: Sbanken.name

  end

  root :to => 'dashboard#index'

end
