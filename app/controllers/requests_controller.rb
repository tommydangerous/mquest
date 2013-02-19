class RequestsController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user, except: [:new, :create, :show, 
										:days_calculation, :request_check_date]
	before_filter :master_user, only: [:destroy]

	# Signed in users
	def new
		@title = 'Request Time Off'
		@request = Request.new
		@purposes = Purpose.order(:name).collect { |p| [p.name, p.id] }
		@@purpose_id = 0
	end

	def create
		sd = params[:request][:request_start]
		ed = params[:request][:request_end]
		if sd > ed
			params[:request][:request_start] = ed
			params[:request][:request_end] = sd
		end
		@request = current_user.requests.new(params[:request])
		@purposes = Purpose.order(:name).collect { |p| [p.name, p.id] }
		date = Date.parse(params[:request][:request_start])
		now = Time.zone.now.to_date
		@purpose_id = params[:request][:purpose_id]
		scheduled = params[:request][:scheduled]
		if params[:request][:request_start] != '' || params[:request][:request_end] != ''
			# check to see if they submitted request within certain date
			if @purpose_id == '15' && date - 2.days >= now || date - 14.days >= now || scheduled == '0'
				conflicts = request_check(@request)
				# if no conflicts, or purpose is sick/unpaid, or request is unscheduled
				if conflicts.empty? || Purpose.find(@purpose_id).name[/sick|unpaid/i] || params[:request][:scheduled] == '0'
			        params[:request][:request_start] = params[:request][:request_start].to_datetime + 12.hour
			        params[:request][:request_end] = params[:request][:request_end].to_datetime + 12.hour
			        @request = current_user.requests.new(params[:request])
					if @request.save
						flash[:success] = 'Request for time off has been successfully submitted.'
						redirect_to requests_user_path(current_user)
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
				if @purpose_id == '15' && date - 2.days < now
					error_msg = ('You must give a 48 hour notice when
						requesting to leave on time')
				else
					error_msg = ('You must give a 14 day notice when
						requesting time off')
				end
				flash.now[:error] = error_msg
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
		@start = Date.parse(date_param(@request.request_start))
		@end = Date.parse(date_param(@request.request_end))
		@days = @request.days.map { |date| Date.parse(date_param(date)) }
		@day_conflicts = @request.conflicts.select { |event| event if event.user_id != @request.user.id }.map(&:event_date).map { |date| Date.parse(date_param(date)) }
		@dept_conflicts = department_conflicts(@request, @request.user).map { |date| Date.parse(date_param(date)) }
		if current_user.admin?
			@decisions = @request.decisions.group_by(&:month_day_year).sort_by { |key, value| key }.reverse
			@conflicts = @request.conflicts.select { |event| event if event.user_id != @request.user.id }.group_by(&:event_date)
		end
		redirect_to current_user unless @request.user == current_user || current_user.admin?
	rescue ActiveRecord::RecordNotFound
		redirect_to root_path
	end

	def days_calculation
		respond_to do |format|
			format.html {
				redirect_to new_request_path
			}
			format.js {
				start_date = params[:start_date]
				end_date = params[:end_date]
				@days = count_days(start_date, end_date)
			}
		end
	end

  def request_check_date
    respond_to do |format|
      format.html {
        redirect_to new_request_path
      }
      format.js {
        start_date = params[:start_date]
        end_date = params[:end_date]
        @conflicts = request_check_date_range(start_date, end_date)
        dates = @conflicts.map { |conflict| conflict.strftime('%b %d, %y') }.join(', ')
        @message = "You cannot take the following days off: #{dates}"
      }
    end
  end

	# Admin users
	def index
		@title = 'Employee Requests'
		@search = Request.search(params[:search]).where('approved = ? AND denied = ?', false, false).order('created_at ASC')
		per_page = params[:view_all] == '1' ? 999 : 10
		@requests = @search.paginate(page: params[:page], per_page: per_page)
		@requests_by_date = @requests.group_by(&:month_day_year)
	end

	def approve
		request = Request.find(params[:id])
		if request.approved?
			flash[:notice] = 'This request has already been approved.'
			redirect_to request
		else
			request.approved = true
			request.approved_by = current_user.id
			request.denied = false
			request.denied_by = nil
			if request.save
				create_decision(request, current_user)
				create_events(request.user, current_user, request)
				request.update_attribute(:total_days, request.events.size) unless request.total_days
				flash[:success] = 'Request has been approved.'
				redirect_to requests_path
			end
		end
	end

	def update
		request = Request.find(params[:id])
		if request.denied?
			flash[:notice] = 'This request has already been denied.'
			redirect_to request
		else
			request.remarks = params[:request][:remarks]
			request.approved = false
			request.approved_by = nil
			request.denied = true
			request.denied_by = current_user.id
			if request.save
				create_decision(request, current_user)
				request.events.destroy_all
				flash[:success] = 'Request has been denied.'
				redirect_to requests_path
			else
				flash[:error] = 'Unable to deny request.'
				redirect_to request
			end
		end
	end

	# Master user
	def destroy
		request = Request.find(params[:id])
		request.destroy
		flash[:notice] = 'Request has been deleted.'
		redirect_to requests_path
	end
end