class SessionsController < ApplicationController

	def new
		if signed_in?
			redirect_to current_user
		else
			@title = "Sign In"
		end
	end

	def create
		redirect_to root_path if signed_in?
		params[:session][:email] = params[:session][:email].downcase
		user = User.authenticate(params[:session][:email], params[:session][:password])
		if user
			if params[:remember_me]
				sign_in user
			else
				sign_in_temp user
			end
			user.in_count = user.in_count + 1
			user.last_in = Time.now
			user.save
			redirect_back_or user
		else
			@title = "Sign In"
			flash.now[:error] = "The email or password you have entered is invalid."
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to signin_path
	end
end