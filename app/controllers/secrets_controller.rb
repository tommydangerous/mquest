class SecretsController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user

	def index
		@title = 'All Secrets'
		@secrets = Secret.all
	end

 	def new
 		@title = 'New Secret'
 		@secret = Secret.new
 	end

 	def create
 		@secret = Secret.new(params[:secret])
 		if @secret.save
 			flash[:success] = 'Secret successfully created.'
 			redirect_to secrets_path
 		else
 			@title = 'New Secret'
 			render 'new'
 		end
 	end

 	def edit
 		@title = 'Edit Secret'
 		@secret = Secret.find(params[:id])
 		render 'new'
 	end

 	def update
 		@secret = Secret.find(params[:id])
 		if @secret.update_attributes(params[:secret])
 			flash[:success] = 'Secret updated.'
 			redirect_to secrets_path
 		else
 			@title = 'Edit Secret'
 			render 'new'
 		end
 	end

 	def destroy
 		Secret.find(params[:id]).destroy
 		flash[:notice] = 'Secret successfully deleted.'
 		redirect_to secrets_path
 	end
end