Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    get 'setup', to: 'users#show'
    get 'ynab_token', to: 'users#edit_ynab_access_token'
    post 'ynab_token', to: 'ufsers#update_access_token'


    resources :sources do
      resources :collections
    end

    resources :budgets do
      post 'enable', to: 'budgets#enable'
      post 'disable', to: 'budgets#disable'
      resources 'accounts' do
        post 'unlink', to: 'accounts#unlink'
      end
    end

    resources :transactions, only: [:clear, :unclear] do
      post 'clear', to: 'transactions#clear'
      post 'unclear', to: 'transactions#unclear'
    end
    post 'transactions/import/:item_id', to: 'transactions#import', as: :transactions_import_item

    post 'sync_budgets', to: 'dashboard#sync_budgets'
    post 'sync_banks', to: 'dashboard#sync_banks'

    get 'sbanken/new', to: 'sources#new', type: Sbanken.name

  end

  root :to => 'dashboard#index'

end
