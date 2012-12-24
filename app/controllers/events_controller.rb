class EventsController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user, except: [:calendar, :day, :month_select]

	# Signed in users
	def calendar
		begin
			Date.parse(params[:date])
			@date = params[:date] ? Date.parse(
				params[:date]) : Time.zone.now.to_date
		rescue
			@date = Time.zone.now.to_date
		end
		if current_user.admin?
			@events = Event.all
		else
			@events = current_user.department_events
		end
		@hash = @events.group_by(&:date)
		@title = @date.strftime("%B %Y")
		render layout: 'calendar_layout'
	end

	def day
		begin
			Date.parse(params[:date])
			@date = params[:date] ? Date.parse(
				params[:date]) : Time.zone.now.to_date
		rescue
			@date = Time.zone.now.to_date
		end
		@title = "#{@date.strftime('%b %-d, %y')}"
		if current_user.admin?
			@events = Event.today(@date).order(
				'created_at').paginate(page: params[:page], per_page: 10)
		else
			@events = current_user.department_events.today(@date).order(
				'created_at').paginate(page: params[:page], per_page: 10)
		end
	end

	def month_select
		m = params[:month]
		y = params[:year]
		if m == '' || m.length > 2 || !m.to_i.between?(1, 12)
			month = Time.zone.now.to_date.month
		else
			month = m
		end
		if y == '' || y.length > 4
			year = Time.zone.now.to_date.year
		else
			year = y
		end
		redirect_to root_path(date: "#{year}-#{month}-#{Time.zone.now.to_date.day}")
	end

	# Admin users
	def index
		@title = 'All Events'
		@search = Event.search(params[:search])
		per_page = params[:view_all] == '1' ? 999 : 10
		@events = @search.order('event_date DESC').paginate(page: params[:page], per_page: per_page)
		@events_by_date = @events.group_by(&:month_day_year)
	end

	def new
		@title = 'New Event'
		@event = Event.new
	end

	def create
		@event = Event.new(params[:event])
		user = User.find_by_name(params[:user_name])
		total_hours = params[:total_hours]
		request_start = params[:event_start].to_datetime + 12.hour
		request_end = params[:event_end].to_datetime + 12.hour
		if !total_hours.blank? && total_hours[/[0-9]+/] && !request_start.blank? && !request_end.blank?
			if user
				if request_start > request_end
					temp_sd = request_start
					temp_ed = request_end
					request_start = temp_ed
					request_end = temp_sd
				end
				if params[:event_name].blank?
					flash.now[:error] = 'Event name cannot be blank.'
					render 'new'
				else
					purpose = Purpose.search(params[:event_name])
					if purpose.empty?
						event_name = params[:event_name].split(' ').map { |word| word.capitalize }.join(' ')
						purpose = Purpose.create!(name: event_name)
					else
						purpose = purpose[0]
					end
					request = user.requests.new(request_start: request_start,
											    request_end: request_end,
											    purpose_id: purpose.id,
											    total_hours: total_hours,
											    scheduled: true)
					if request.save
						request.approved = true
						request.approved_by = current_user.id
						request.manual = true
						request.manual_by = current_user.id
						request.save
						create_decision(request, current_user)
						create_events(user, current_user, request)
						request.update_attribute(:total_days, request.events.size)
						flash[:success] = 'Event(s) successfully created.'
						redirect_to request
					else
						flash.now[:error] = 'Unable to create events and request.'
						render 'new'
					end
				end
			else
				@title = 'New Event'
				flash.now[:error] = 'Unable to find user by that name.'
				render 'new'
			end
		else
			flash.now[:error] = 'Start date, end date, and total hours cannot be blank.'
			render 'new'
		end
	end

	def edit
		@event = Event.find(params[:id])
		@title = 'Edit Event'
	end

	def update
		@event = Event.find(params[:id])
		user = User.find_by_name(params[:user_name])
		if user
			params[:event][:event_date] = params[:event][:event_date].to_datetime
			if @event.update_attributes(params[:event])
				@event.user_id = user.id
				if @event.save
					flash[:success] = 'Event successfully updated.'
					redirect_to events_path
				else
					@title = 'Edit Event'
					flash.now[:error] = 'Event was not able to save.'
					render 'edit'
				end
			else
				@title = 'Edit Event'
				render 'edit'
			end
		else
			@title = 'Edit Event'
			flash.now[:error] = 'Unable to find user by that name.'
			render 'edit'
		end
	end

	def destroy
		event = Event.find(params[:id])
		event.destroy
		flash[:notice] = 'Event was successfully deleted.'
		redirect_to events_path
	end
end