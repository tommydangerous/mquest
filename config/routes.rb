Mquest::Application.routes.draw do

  get "secrets/new"

	resources :events
	resources :requests do
		member do
			get :approve
			get :deny
		end
	end
	resources :secrets
	resources :sessions
	resources :users do
		member do
			get :events
		end
	end

	# Events
	root to: 'events#calendar'
	match 'day' => 'events#day', as: 'day'
	match 'month-select' => 'events#month_select', as: 'month_select'

	# Sessions
	match 'sign-in' => 'sessions#new', as: 'signin'
	match 'sign-out' => 'sessions#destroy', as: 'signout'

	# Users
	match 'sign-up' => 'users#new', as: 'signup'
	match 'user-list' => 'users#user_list', as: 'user_list'

	# 404
	match '*url' => 'pages#not_found', as: 'not_found'
end