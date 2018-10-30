Rails.application.routes.draw do
  resources :users, only: [:index]
  root 'users#index'

  get 'users/:name', to: "users#get_user_data"

  post 'saveData', to: "users#save_data"
  get 'getData', to: "users#get_data"
end
