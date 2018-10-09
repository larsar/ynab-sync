Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    get 'setup', to: 'users#show'
    get 'ynab_token', to: 'users#edit_ynab_access_token'
    post 'ynab_token', to: 'users#update_access_token'

    resources :budgets
    post 'sync_budgets', to: 'home#sync_budgets'

    resources :services
    get 'sbanken/new', to: 'services#new', type: Service::SBANKEN
    resources :ynab_accounts

  end

  root :to => 'home#index'

end
