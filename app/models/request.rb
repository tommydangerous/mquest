class Request < ActiveRecord::Base
 	attr_accessible :request_start,
 					:request_end,
 					:total_days,
 					:total_hours,
 					:purpose,
 					:comments,
 					:scheduled,
 					:called_in,
 					:absence_paid,
 					:remarks

 	belongs_to :user

 	has_many :events, dependent: :destroy
 	
 	validates :request_start, presence: true
 	validates :request_end, presence: true
 	validates :total_hours, presence: true
 	validates :user_id, presence: true

 	def self.search(search)
 		if search
 			where("purpose ILIKE ? OR comments ILIKE ?", "%#{search}%", "%#{search}%")
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
 		Event.where('event_date >= ? AND event_date <= ?', sd, ed)
 	end

 	def month_day_year
 		month_name = self.created_at.strftime('%B')
 		month = self.created_at.strftime('%m')
 		day = self.created_at.strftime('%d')
 		year = self.created_at.strftime('%y')
 		[month_name, month, day, year]
 	end
end