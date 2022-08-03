Rails.application.routes.draw do
  resources :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/user' => 'admins#user'
  # Defines the root path route ("/")
  root "admins#index"
end
