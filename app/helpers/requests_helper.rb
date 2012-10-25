module RequestsHelper

	def request_purpose
		[
			'Bereavement',
			'Jury Duty',
			'Leave of Absence',
			'Personal',
			'Sick',
			'Unpaid Time Off',
			'Vacation',
			'Volunteer',
			'Vote'
		]
	end

	def create_events(user, approver, request)
		sd = request.request_start
		ed = request.request_end
		mn = request.request_start.month
		yr = request.request_start.year
		days_month = Time.days_in_month(mn, year = yr)
		if sd > ed
			temp_ed = sd
			temp_sd = ed
			sd = temp_sd
			ed = temp_ed
		end
		if ed.day - sd.day < 0
			(sd.day..days_month).to_a.each do |day|
				event_date = Time.zone.parse("#{sd.year}-#{sd.month}-#{day}")
				if event_date.strftime('%A') != 'Sunday' && event_date.strftime('%A') != 'Saturday'
					user.events.create!(name: request.purpose,
										event_date: event_date,
										date_requested: request.created_at,
										approved_by: approver.id,
										request_id: request.id)
				end
			end
			(1..ed.day).to_a.each do |day|
				event_date = Time.zone.parse("#{ed.year}-#{ed.month}-#{day}")
				if event_date.strftime('%A') != 'Sunday' && event_date.strftime('%A') != 'Saturday'
					user.events.create!(name: request.purpose,
										event_date: event_date,
										date_requested: request.created_at,
										approved_by: approver.id,
										request_id: request.id)
				end
			end
		elsif ed.day - sd.day == 0
			event_date = Time.zone.parse("#{sd.year}-#{sd.month}-#{sd.day}")
			user.events.create!(name: request.purpose,
								event_date: event_date,
								date_requested: request.created_at,
								approved_by: approver.id,
								request_id: request.id)
		else
			(sd.day..ed.day).to_a.each do |day|
				event_date = Time.zone.parse("#{sd.year}-#{sd.month}-#{day}")
				if event_date.strftime('%A') != 'Sunday' && event_date.strftime('%A') != 'Saturday'
					user.events.create!(name: request.purpose,
										event_date: event_date,
										date_requested: request.created_at,
										approved_by: approver.id,
										request_id: request.id)
				end
			end
		end
	end

	def request_check(request)
		department = current_user.department
		conflicts = request.conflicts
		conflict_days = []
		if conflicts
			conflicts.group_by(&:event_date).each do |conflict|
				date = conflict[0]
				events = conflict[1]
				department_ids = events.map { |event| event.user.department_id if event.user != current_user }
				if department_ids.count(department.id) >= department.max_off
					conflict_days.append(date)
				end
			end
		end
		conflict_days
	end
end