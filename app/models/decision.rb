class Decision < ActiveRecord::Base
	attr_accessible :name

	belongs_to :request
	belongs_to :user

	def month_day_year
 		month_name = self.created_at.strftime('%b')
 		month = self.created_at.strftime('%m')
 		day = self.created_at.strftime('%d')
 		year = self.created_at.strftime('%y')
 		[month_name, month, day, year]
 	end
end