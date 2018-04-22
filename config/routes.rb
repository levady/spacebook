Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "application#root"

  post :relationships, to: 'relationships#create'
  post :friends, to: 'relationships#index'
  post :common_friends, to: 'relationships#common_friends'
  post :follow, to: 'relationships#follow'
  post :block, to: 'relationships#block'
end
