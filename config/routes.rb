Rails.application.routes.draw do
  resources :users, only: [:index]
  root 'users#index'

  get 'users/:name', to: "users#get_user_data"
  get 'learnapidata/:id', to: "users#test_get_full_history_data"

  post 'saveData', to: "users#save_data"
  get 'getData', to: "users#get_data"
end
