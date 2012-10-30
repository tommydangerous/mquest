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