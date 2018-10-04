Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    get 'profile', to: 'users#show'

    #match 'services/:type/new', to: 'services#new', :via => [:get], as: 'new_service'

    resources :services, only: [:index]  do
      #resources :transactions, only: [:index]
    end

    resources :ynab_services, :controller => 'services', type: Service::TYPE_YNAB

  end

  root :to => 'home#index'

end
