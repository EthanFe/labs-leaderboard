Rails.application.routes.draw do
  resources :users, only: [:index]
  root 'users#index'

  get 'users/:name', to: "users#get_user_data"

  post 'saveData', to: "users#save_data"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
