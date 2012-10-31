Mquest::Application.routes.draw do

	resources :departments do
		member do
			get :requests
			get :users
		end
	end
	resources :events
	resources :purposes do
		member do
			get :requests
		end
	end
	resources :requests do
		member do
			get :approve
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

	# Pages
	match 'test' => 'pages#test', as: 'test'

	# Purpose
	match 'purpose-list' => 'purposes#purpose_list', as: 'purpose_list'

	# Sessions
	match 'sign-in' => 'sessions#new', as: 'signin'
	match 'sign-out' => 'sessions#destroy', as: 'signout'

	# Users
	match 'department-secret' => 'users#department_secret', as: 'department_secret'
	match 'sign-up' => 'users#new', as: 'signup'
	match 'user-list' => 'users#user_list', as: 'user_list'

	# 404
	match '*url' => 'pages#not_found', as: 'not_found'
end