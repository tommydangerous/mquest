class UsersController < ApplicationController
	before_filter :authenticate, except: [:department_secret, :new, :create]
	before_filter :correct_user_admin_user, only: [:edit, :update, :show, 
												   :events, :requests]
	before_filter :admin_user, only: [:index, :user_list]
	before_filter :master_user, only: [:destroy]

	# All users
	def department_secret
		respond_to do |format|
			format.html {
				redirect_to signin_path
			}
			format.js {
				secret = Secret.find_by_name('Sign Up')
				code = secret ? secret.code : 'lotus'
				if params[:secret_code] == code
					@verify = true
				else
					@verify = false
				end
			}
		end
	end

	def new
		@title = 'Sign Up'
		@user = User.new
	end

	def create
		secret = Secret.find_by_name('Sign Up')
		code = secret ? secret.code : 'lotus'
		params[:user][:email] = params[:user][:email].downcase
		params[:user][:name] = params[:user][:name].split(' ').map { |word| word.capitalize }.join(' ')
		@user = User.new(params[:user])
		if params[:secret_code] == code
			if Department.find_by_id(params[:user][:department_id])
				if @user.save
					@user.in_count = 1
					@user.last_in = Time.now
					@user.save
					flash[:success] = "User successfully created."
					sign_in @user
					redirect_to @user
				else
					@title = 'Sign Up'
					render 'new'
				end
			else
				flash.now[:error] = 'Could not find that department.'
	  			render 'new'
			end
		else
			flash.now[:error] = 'The secret code you entered is incorrect, please try again.'
			render 'new'
		end
	end

	# Correct user
	def edit
		@title = "Edit Profile"
		@user = User.find(params[:id])
		if @user.master? && !current_user.master?
			flash[:notice] = 'You cannot edit the master user.'
			redirect_to edit_user_path(current_user)
		end
	end

	def update
		params[:user][:email] = params[:user][:email].downcase
		params[:user][:name] = params[:user][:name].split(' ').map { |word| word.capitalize }.join(' ')
		@user = User.find(params[:id])
		if @user.master? && !current_user.master?
			flash[:notice] = 'You cannot edit the master user.'
			redirect_to edit_user_path(@user)
		else
			if current_user.admin?
				if Department.find_by_id(params[:user][:department_id])
			  		if @user.update_attributes(params[:user])
			  			if params[:user][:password].length >= 2 && params[:user][:password_confirmation].length >= 2 && @user == current_user
			  				flash[:success] = "Password changed. Please sign in with your new password."
							sign_out
							redirect_to signin_path
						else
							flash[:success] = "User profile has been updated."
					  		redirect_to @user
					  	end
			  		else
			  			@title = "Edit Profile"
			  			render 'edit'
			  		end
			  	else
			  		flash.now[:error] = 'Could not find that department.'
			  		render 'edit'
			  	end
			elsif params[:user][:department_id]
				flash.now[:error] = 'Only admin users can edit your department.'
				render 'edit'
			else
				if @user.update_attributes(params[:user])
		  			if params[:user][:password].length >= 2 && params[:user][:password_confirmation].length >= 2 && @user == current_user
		  				flash[:success] = "Password changed. Please sign in with your new password."
						sign_out
						redirect_to signin_path
					else
						flash[:success] = "User profile has been updated."
				  		redirect_to @user
				  	end
		  		else
		  			@title = "Edit Profile"
		  			render 'edit'
		  		end
			end
		end
	end

	def show
		@user = User.find(params[:id])
		@title = "#{@user.name}"
		@requests = @user.requests
		@approved = @user.requests.where('approved = ?', true)
		@events = @user.events
		request_ids = @user.events.map { |event| event.request_id }.uniq
		if request_ids.empty?
			requests = []
			@hours = 0
		else
			requests = Request.where("id IN (#{request_ids.join(', ')})")
			@hours = requests.select { |request| request.total_hours }.map { |request| request.total_hours }.sum
		end
		now = [Time.now.year, Time.now.month, Time.now.day].join('-').to_datetime
		@next_event = @user.events.where('event_date >= ?', now).order('event_date ASC').first
	end

	def events
		@user = User.find(params[:id])
		@title = "#{@user.name}'s Events"
		@search = @user.events.search(params[:search])
		per_page = params[:view_all] == '1' ? 999 : 10
		@events = @search.order('event_date DESC').paginate(page: params[:page], per_page: per_page)
		@events_by_date = @events.group_by(&:month_day_year)
		request_ids = @search.map { |event| event.request_id }.uniq
		if request_ids.empty?
			requests = []
			@hours = 0
		else
			requests = Request.where("id IN (#{request_ids.join(', ')})")
			@hours = requests.select { |request| request.total_hours }.map { |request| request.total_hours }.sum
		end
	end

	def requests
		@user = User.find(params[:id])
		@title = "#{@user.name}'s Requests"
		@search = @user.requests.search(params[:search])
		per_page = params[:view_all] == '1' ? 999 : 10
		@requests = @search.order('created_at DESC').paginate(page: params[:page], per_page: per_page)
		@requests_by_date = @requests.group_by(&:month_day_year)
		@approved = @search.where('approved = ?', true)
	end

	# Admin users
	def index
		@title = 'All Users'
		@search = User.search(params[:search])
		per_page = params[:view_all] == '1' ? 999 : 20
		@users = @search.order('name ASC').paginate(page: params[:page], per_page: per_page)
	end

	def user_list
		@users = User.search(params[:term]).order(:name)
		render json: @users.map(&:name)
	end

	# Master user
	def destroy
		user = User.find(params[:id])
		if user.admin?
			flash[:error] = 'You cannot delete an admin user.'
			redirect_to users_path
		else
			user.destroy
			flash[:notice] = 'User has been deleted.'
			redirect_to users_path
		end
	end
end