class Event < ActiveRecord::Base
	attr_accessible :name,
					:event_date,
					:date_requested,
					:approved_by,
					:request_id
	
	belongs_to :user
	belongs_to :request

	validates :name, presence: true
	validates :event_date, presence: true
	validates :user_id, presence: true, on: :create
	validates :request_id, presence: true

	def self.search(search)
 		if search
 			where("name ILIKE ?", "%#{search}%")
 		else
 			scoped
 		end
 	end

 	def month_day_year
 		month_name = self.event_date.strftime('%B')
 		month = self.event_date.strftime('%m')
 		day = self.event_date.strftime('%d')
 		year = self.event_date.strftime('%y')
 		[month_name, month, day, year]
 	end
end