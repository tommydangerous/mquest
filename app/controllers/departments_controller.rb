class DepartmentsController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user

	def index
		@title = 'All Departments'
		@search = Department.search(params[:search]).order(:name)
		per_page = params[:view_all] == '1' ? 999 : 20
		@departments = @search.paginate(page: params[:page], per_page: per_page)
	end

	def new
		@title = 'New Department'
		@department = Department.new
	end

	def create
		@department = Department.new(params[:department])
		params[:department][:name] = params[:department][:name].split(' ').map { |word| word.capitalize }.join(' ')
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

	def destroy
		department = Department.find(params[:id])
		if department.users.empty?
			flash[:success] = 'Department deleted.'
			department.destroy
		else
			flash[:notice] = 'You cannot delete a department that has users.'
		end
		redirect_to departments_path
	end

	def requests
		@department = Department.find(params[:id])
		@title = "#{@department.name} Requests"
		@search = @department.requests
		per_page = params[:view_all] == '1' ? 999 : 10
		@requests = @search.paginate(page: params[:page], per_page: per_page)
		@requests_by_date = @requests.group_by(&:month_day_year)
		render 'requests/index'
	end

	def users
		@department = Department.find(params[:id])
		@title = "#{@department.name} Users"
		@search = @department.users.search(params[:search])
		per_page = params[:view_all] == '1' ? 999 : 10
		@users = @search.order('name ASC').paginate(page: params[:page], per_page: per_page)
		render 'users/index'
	end
end