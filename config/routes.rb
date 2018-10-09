Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    get 'setup', to: 'users#show'
    get 'ynab_token', to: 'users#edit_ynab_access_token'
    post 'ynab_token', to: 'users#update_access_token'

    resources :budgets, :sources, :collections
    resources :accounts do
      post 'unlink', to: 'accounts#unlink'
    end
    post 'sync_budgets', to: 'dashboard#sync_budgets'
    post 'sync_banks', to: 'dashboard#sync_banks'

    get 'sbanken/new', to: 'sources#new', type: Source::SBANKEN

  end

  root :to => 'dashboard#index'

end
