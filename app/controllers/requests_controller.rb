class RequestsController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user, except: [:new, :create, :show]

	# Signed in users
	def new
		@title = 'Request Time Off'
		@request = Request.new
	end

	def create
		@request = current_user.requests.new(params[:request])
		if params[:request][:request_start] != '' || params[:request][:request_end] != ''
			conflicts = request_check(@request)
			if conflicts.empty?
				if @request.save
					flash[:success] = 'Request for time off has been successfully submitted.'
					redirect_to current_user
				else
					@title = 'Time Off Request'
					render 'new'
				end
			else
				dates = conflicts.map { |conflict| conflict.strftime('%b %d, %y') }.join(', ')
				flash.now[:error] = "You cannot take the following days off: #{dates}"
				render 'new'
			end
		else
			flash.now[:error] = 'Both start and end dates requested cannot be blank.'
			render 'new'
		end
	end

	def show
		@title = 'Time Off Request'
		@request = Request.find(params[:id])
		@conflicts = @request.conflicts if current_user.admin?
		@day_conflicts = @request.conflicts.map(&:event_date).map { |date| Date.parse(date_param(date)) }
		@start = Date.parse(date_param(@request.request_start))
		@end = Date.parse(date_param(@request.request_end))
		redirect_to current_user unless @request.user == current_user || current_user.admin?
	rescue ActiveRecord::RecordNotFound
		redirect_to root_path
	end

	# Admin users
	def index
		@title = 'Employee Requests'
		@search = Request.search(params[:search]).where('approved = ? AND denied = ?', false, false).order('created_at ASC')
		@requests = @search.paginate(page: params[:page], per_page: 10)
	end

	def approve
		request = Request.find(params[:id])
		request.approved = true
		request.denied = false
		if request.save
			create_events(request.user, current_user, request)
			request.update_attribute(:total_days, request.events.size) unless request.total_days
			flash[:success] = 'Request has been approved.'
			redirect_to requests_path
		end
	end

	def update
		request = Request.find(params[:id])
		request.remarks = params[:request][:remarks]
		request.approved = false
		request.denied = true
		if request.save
			request.events.destroy_all
			flash[:success] = 'Request has been denied.'
			redirect_to requests_path
		else
			flash[:error] = 'Unable to deny request.'
			redirect_to request
		end
	end

	def deny
		request = Request.find(params[:id])
		request.remarks = params[:request][:remarks]
		request.approved = false
		request.denied = true
		if request.save
			request.events.destroy_all
			flash[:success] = 'Request has been denied.'
			redirect_to requests_path
		else
			flash[:error] = 'Unable to deny request.'
			redirect_to request
		end
	end
end