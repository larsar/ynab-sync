Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    get 'profile', to: 'users#show'

    get 'ynab', to: 'users#edit_ynab_access_token'
    post 'ynab', to: 'users#update_access_token'

    #match 'services/:type/new', to: 'services#new', :via => [:get], as: 'new_service'

    resources :services do
      #resources :transactions, only: [:index]
    end

    resources :ynab_services, :controller => 'services', type: Service::TYPE_YNAB
    resources :budgets
    post 'budgets/sync', to: 'budgets#sync'
    resources :ynab_accounts


  end

  root :to => 'home#index'

end
