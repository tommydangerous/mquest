class DepartmentsController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user

	def index
		@title = 'All Departments'
		@departments = Department.order(:name)
	end

	def new
		@title = 'New Department'
		@department = Department.new
	end

	def create
		params[:department][:name] = params[:department][:name].split(' ').map { |word| word.capitalize }.join(' ')
		@department = Department.new(params[:department])
		if params[:department][:max_off][/[0-9]+/]
			if @department.save
				flash[:success] = 'Department successfully created.'
				redirect_to departments_path
			else
				@title = 'New Department'
				render 'new'
			end
		else
			flash.now[:error] = 'Max employees off per day must be a number.'
			render 'new'
		end
	end

	def edit
		@title = 'Edit Department'
		@department = Department.find(params[:id])
		render 'new'
	end

	def update
		@department = Department.find(params[:id])
		params[:department][:name] = params[:department][:name].split(' ').map { |word| word.capitalize }.join(' ')
		if params[:department][:max_off][/[0-9]+/]
			if @department.update_attributes(params[:department])
				flash[:success] = 'Department successfully updated.'
				redirect_to departments_path
			else
				@title = 'Edit Department'
				render 'new'
			end
		else
			flash.now[:error] = 'Max employees off per day must be a number.'
			render 'new'
		end
	end
end