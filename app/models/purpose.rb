# == Schema Information
#
# Table name: purposes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Purpose < ActiveRecord::Base
	attr_accessible :name

	has_many :requests
	has_many :events

	validates :name, presence: true
	validates_uniqueness_of :name

	def self.search(search)
		if search
			where("name ILIKE ?", "%#{search}%")
		else
			scoped
		end
	end
end
