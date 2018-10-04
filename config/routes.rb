Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
  end

  root :to => 'home#index'

end
