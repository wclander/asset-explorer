Rails.application.routes.draw do
  get 'list/view'
  get 'list/search'
  get 'list/categories'
  get 'assets/view'
  get 'assets/search'
  get 'assets/total'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'welcome#index'
  get '/eve_callback', to: 'oauth#oauth_callback'
  get '/logout', to: 'oauth#logout'
  get '/login', to: 'oauth#login'
end
