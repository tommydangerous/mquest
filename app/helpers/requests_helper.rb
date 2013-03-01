module RequestsHelper

	def create_events(user, approver, request)
		sd = request.request_start.to_datetime
		ed = request.request_end.to_datetime
		if sd > ed
			temp_ed = sd
			temp_sd = ed
			sd = temp_sd
			ed = temp_ed
		end
		mn = request.request_start.month
		yr = request.request_start.year
		if (ed - sd).to_i == 0
			event_date = Time.zone.parse("#{sd.year}-#{sd.month}-#{sd.day}")
			user.events.create!(purpose_id: request.purpose.id,
								event_date: event_date,
								date_requested: request.created_at,
								approved_by: approver.id,
								request_id: request.id)
		else
			date_array = []
			sd.upto(ed) { |date| date_array.push(date) }
			date_array.each do |day|
				if day.strftime('%A') != 'Sunday' && day.strftime('%A') != 'Saturday'
					user.events.create!(purpose_id: request.purpose.id,
										event_date: day,
										date_requested: request.created_at,
										approved_by: approver.id,
										request_id: request.id)
				end
			end
		end
	end

	def count_days(start_date, end_date)
		days = 0
		sd = start_date.to_datetime
		ed = end_date.to_datetime
		if sd > ed
			temp_ed = sd
			temp_sd = ed
			sd = temp_sd
			ed = temp_ed
		end
		mn = sd.month
		yr = sd.year
		if (ed - sd).to_i == 0
			days += 1
		else
			date_array = []
			sd.upto(ed) { |date| date_array.push(date) }
			date_array.each do |day|
				if day.strftime('%A') != 'Sunday' && day.strftime('%A') != 'Saturday'
					days += 1
				end
			end
		end
		days
	end

	def create_decision(request, user)
		if request.approved?
			action = 'Approved'
		elsif request.denied?
			action = 'Denied'
		end
		decision = Decision.create!(name: action.capitalize)
		decision.request_id = request.id
		decision.user_id = user.id
		decision.save
	end

	def return_conflict_days(conflicts)
		department = current_user.department
		conflict_days = []
 		if conflicts
			conflicts.group_by(&:date).each do |conflict|
				date = conflict[0]
				events = conflict[1]
				department_ids = events.map { |event| event.user.department_id if event.user != current_user }
				if department_ids.count(department.id) >= department.max_off
					conflict_days.append(date.to_datetime)
				end
			end
		end
		conflict_days.sort
	end

	def request_check(request)
		conflicts = request.conflicts
		return_conflict_days(conflicts)
	end

	def request_check_date_range(start_date, end_date)
		sd = start_date
		ed = end_date
		if sd > ed
			temp_ed = sd
			temp_sd = ed
			sd = temp_sd
			ed = temp_ed
		end
		sd = sd.to_date.to_datetime
		ed = ed.to_date.to_datetime + 23.hours + 59.minutes + 59.seconds
 		conflicts = Event.where(event_date: sd..ed).order('event_date DESC')
		return_conflict_days(conflicts)
	end

	def department_conflicts(request, user)
		department = user.department
		conflicts = request.conflicts
		conflict_days = []
		if conflicts
			conflicts.group_by(&:event_date).each do |conflict|
				date = conflict[0]
				events = conflict[1]
				department_ids = events.map { |event| event.user.department_id if event.user != user }
				if department_ids.count(department.id) >= department.max_off
					conflict_days.append(date)
				end
			end
		end
		conflict_days.sort
	end

	def request_note
		"Per Company Policy, your supervisor may deny your request at "\
		"his/her discretion if granting the request will negatively "\
		"impact the business needs of your department. When possible, "\
		"follow your department\'s specific lead time requirements for "\
		"all requests."
	end

	def request_disclaimer
		"Your supervisor may request proof of available hours "\
		"(obtained from your ADP Pay Statement). All requests are "\
		"verified by P/R before they are processed in the correct "\
		"payroll period to ensure hours are available. Any time off "\
		"that cannot be covered by accrued hours will be considered "\
		"UNPAID."
	end
end