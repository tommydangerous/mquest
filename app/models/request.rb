# == Schema Information
#
# Table name: requests
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  request_start :datetime
#  request_end   :datetime
#  total_days    :integer
#  total_hours   :integer
#  comments      :text
#  scheduled     :boolean
#  called_in     :boolean
#  absence_paid  :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  approved      :boolean          default(FALSE)
#  denied        :boolean          default(FALSE)
#  remarks       :text
#  manual        :boolean          default(FALSE)
#  approved_by   :integer
#  denied_by     :integer
#  manual_by     :integer
#  purpose_id    :integer
#  half_day      :boolean          default(FALSE)
#

class Request < ActiveRecord::Base
 	attr_accessible :half_day,
 									:request_start,
				 					:request_end,
				 					:total_days,
				 					:total_hours,
				 					:purpose,
				 					:comments,
				 					:scheduled,
				 					:called_in,
				 					:absence_paid,
				 					:remarks,
				 					:purpose_id

 	belongs_to :purpose
 	belongs_to :user

 	has_many :events, dependent: :destroy
 	has_many :decisions, dependent: :destroy
 	
 	validates :request_start, presence: true
 	validates :request_end, presence: true
 	validates :total_hours, presence: true
 	validates :purpose_id, presence: true
 	validates :user_id, presence: true

 	def self.search(search)
 		purposes = Purpose.where("name ILIKE ?", "%#{search}%").map(&:id).join(', ')
 		if purposes.empty?
 			purposes = "NULL"
 		end
 		if search
 			where("purpose_id IN (#{purposes}) OR comments ILIKE ?", "%#{search}%")
 		else
 			scoped
 		end
 	end

 	def conflicts
 		sd = self.request_start
 		ed = self.request_end
 		if sd > ed
			temp_ed = sd
			temp_sd = ed
			sd = temp_sd
			ed = temp_ed
		end
		sd = sd.to_date.to_datetime
		ed = ed.to_date.to_datetime + 23.hours + 59.minutes + 59.seconds
		Event.where(event_date: sd..ed).order('event_date DESC')
 		# Event.where('event_date >= ? AND event_date <= ?', 
 		#		sd, ed).order('event_date DESC')
 	end

 	def days
 		sd = self.request_start
 		ed = self.request_end
 		mn = sd.month
		yr = sd.year
		days_month = Time.days_in_month(mn, year = yr)
 		if sd > ed
			temp_ed = sd
			temp_sd = ed
			sd = temp_sd
			ed = temp_ed
		end
		days = []
		if ed.day - sd.day < 0
			(sd.day..days_month).to_a.each do |day|
				event_date = Time.zone.parse("#{sd.year}-#{sd.month}-#{day}")
				if event_date.strftime('%A') != 'Sunday' && event_date.strftime('%A') != 'Saturday'
					days.append(event_date)
				end
			end
			(1..ed.day).to_a.each do |day|
				event_date = Time.zone.parse("#{ed.year}-#{ed.month}-#{day}")
				if event_date.strftime('%A') != 'Sunday' && event_date.strftime('%A') != 'Saturday'
					days.append(event_date)
				end
			end
		elsif ed.day - sd.day == 0
			event_date = Time.zone.parse("#{sd.year}-#{sd.month}-#{sd.day}")
			days.append(event_date)
		else
			(sd.day..ed.day).to_a.each do |day|
				event_date = Time.zone.parse("#{sd.year}-#{sd.month}-#{day}")
				if event_date.strftime('%A') != 'Sunday' && event_date.strftime('%A') != 'Saturday'
					days.append(event_date)
				end
			end
		end
		days
 	end

 	def half_day_check
 		# Check to see if the number of half day requests exceed 
 		# the half day max off
 		conflict_days = []
 		if self.conflicts
 			self.conflicts.group_by(&:date).each do |conflict|
 				date   = conflict[0]
 				events = conflict[1]
 				half_day_events = events.select { |event| event.request.half_day }
 				weekday_of_date = Time.zone.parse(date).strftime('%w').to_i + 1
 				hf_day = HalfDay.find(weekday_of_date)
 				if half_day_events.size >= hf_day.max_off
 					conflict_days.append(date.to_datetime)
 				end
 			end
 		end
 		conflict_days.sort
 	end

 	def month_day_year
 		month_name = self.created_at.strftime('%B')
 		month = self.created_at.strftime('%m')
 		day = self.created_at.strftime('%d')
 		year = self.created_at.strftime('%y')
 		[month_name, month, day, year]
 	end

 	def user_approved
 		User.find(self.approved_by)
 	end

 	def user_denied
 		User.find(self.denied_by)
 	end

 	def user_manual
 		User.find(self.manual_by)
 	end
end
