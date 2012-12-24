class Event < ActiveRecord::Base
	attr_accessible :event_date,
					:date_requested,
					:approved_by,
					:request_id,
					:purpose_id
	
	belongs_to :user
	belongs_to :request
	belongs_to :purpose

	validates :event_date, presence: true
	validates :user_id, presence: true, on: :create
	validates :request_id, presence: true
	validates :purpose_id, presence: true

	scope :today, lambda { |date| where(event_date: (date)..(date + 1)) }

	def self.search(search)
		purposes = Purpose.where("name ILIKE ?", "%#{search}%")
		if purposes.empty?
			purpose_ids = "NULL"
		else
			purpose_ids = purposes.map { |purpose| purpose.id }.join(', ')
		end
 		if search
 			where("purpose_id IN (#{purpose_ids})")
 		else
 			scoped
 		end
 	end

 	def date
 		self.event_date.strftime('%Y-%m-%d')
 	end

 	def month_day_year
 		month_name = self.event_date.strftime('%B')
 		month = self.event_date.strftime('%m')
 		day = self.event_date.strftime('%d')
 		year = self.event_date.strftime('%y')
 		[month_name, month, day, year]
 	end
end