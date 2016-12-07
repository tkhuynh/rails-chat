Rails.application.routes.draw do
  get 'home/index'

	root 'home#index'
	
  devise_for :users

  resources :conversations, only: [:create] do
  	member do
  		post :close
  	end
  end
  
end
