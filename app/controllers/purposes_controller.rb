class PurposesController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user

	def index
		@title = 'All Purposes'
		@search = Purpose.search(params[:search])
		per_page = params[:view_all] == '1' ? 999 : 20
		@purposes = @search.paginate(page: params[:page], per_page: per_page)
	end

	def new
		@title = 'New Purpose'
		@purpose = Purpose.new
	end

	def create
		@purpose = Purpose.new(params[:purpose])
		params[:purpose][:name] = params[:purpose][:name].split(' ').map { |word| word.capitalize }.join(' ')
		if @purpose.save
			flash[:success] = 'Purpose successfully created.'
			redirect_to purposes_path
		else
			@title = 'New Purpose'
			render 'new'
		end
	end

	def edit
		@title = 'Edit Purpose'
		@purpose = Purpose.find(params[:id])
		render 'new'
	end

	def update
		@purpose = Purpose.find(params[:id])
		params[:purpose][:name] = params[:purpose][:name].split(' ').map { |word| word.capitalize }.join(' ')
		if @purpose.update_attributes(params[:purpose])
			flash[:success] = 'Purpose successfully updated.'
			redirect_to purposes_path
		else
			@title = 'Edit Purpose'
			render 'new'
		end
	end

	def requests
		@purpose = Purpose.find(params[:id])
		@title = "#{@purpose.name.titleize} Requests"
		@search = @purpose.requests.search(params[:search])
		per_page = params[:view_all] == '1' ? 999 : 10
		@requests = @search.paginate(page: params[:page], per_page: per_page)
		@requests_by_date = @requests.group_by(&:month_day_year)
		render 'requests/index'
	end

	def destroy
		purpose = Purpose.find(params[:id])
		if purpose.requests.empty?
			flash[:success] = 'Purpose deleted.'
			purpose.destroy
		else
			flash[:notice] = 'You cannot delete a purpose that has requests.'
		end
		redirect_to purposes_path
	end

	def purpose_list
		@purposes = Purpose.search(params[:term]).order(:name)
		render json: @purposes.map(&:name)
	end
end