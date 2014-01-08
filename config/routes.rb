Mayors::Application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  get '/users/auth/:provider/callback', to: 'sessions#create'

  root :to => 'home#index'
end
