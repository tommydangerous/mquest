# == Schema Information
#
# Table name: decisions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  request_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
