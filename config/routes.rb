Rails.application.routes.draw do
  resources :admins
  resources :words
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/user' => 'admins#user'
  get '/error' => 'admins#error'
  
  # Defines the root path route ("/")
  root "admins#index"

  get '/typeahead/:input' => 'admins#typeahead'
  # get '/typeahead/:input' => '/https://api.dictionaryapi.dev/api/v2/entries/en/:input'
  # get '/https://api.dictionaryapi.dev/api/v2/entries/en/:input' => 'admins#typeahead'

  # get "/typeahead/:input" => redirect("/api.dictionaryapi.dev/api/v2/entries/en/cat")

end
