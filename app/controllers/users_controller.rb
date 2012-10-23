class UsersController < ApplicationController
	before_filter :authenticate, except: [:new, :create]
	before_filter :correct_user_admin_user, only: [:edit, :update, :events]
	before_filter :admin_user, only: [:index, :destroy, :user_list]

	# All users
	def new
		@title = 'Sign Up'
		@user = User.new
	end

	def create
		secret = Secret.find_by_name('Sign Up')
		code = secret ? secret.code : 'lotus'
		params[:user][:email] = params[:user][:email].downcase
		@user = User.new(params[:user])
		if params[:secret_code] == code
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
			flash[:error] = 'The secret code you entered is incorrect, please try again.'
			render 'new'
		end
	end

	# Correct user
	def edit
		@title = "Edit Profile"
		@user = User.find(params[:id])
	end

	def update
		params[:user][:email] = params[:user][:email].downcase
		@user = User.find(params[:id])
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

	def events
		@user = User.find(params[:id])
		@title = "#{@user.name}'s Events"
		@search = @user.events.search(params[:search])
		@events = @search.order('event_date DESC').paginate(page: params[:page], per_page: 10)
		request_ids = @search.map { |event| event.request_id }.uniq.join(', ')
		requests = Request.where("id IN (#{request_ids})")
		@hours = requests.select { |request| request.total_hours }.map { |request| request.total_hours }.sum
	end

	def show
		@user = User.find(params[:id])
		@title = "#{@user.name}'s Requests"
		@search = @user.requests.search(params[:search])
		@requests = @search.order('created_at DESC').paginate(page: params[:page], per_page: 10)
		redirect_to current_user unless @user == current_user || current_user.admin?
	rescue ActiveRecord::RecordNotFound
		redirect_to root_path
	end

	# Admin users
	def index
		@title = 'All Users'
		@search = User.search(params[:search])
		@users = @search.order('name ASC').paginate(page: params[:page], per_page: 20)
	end

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

	def user_list
		if Rails.env.production?
			@users = User.order(:name).where("name ILIKE ?", "%#{params[:term]}%")
		else
			@users = User.order(:name).where("name LIKE ?", "%#{params[:term]}%")
		end
		render json: @users.map(&:name)
	end
end