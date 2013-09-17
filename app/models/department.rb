# == Schema Information
#
# Table name: departments
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  max_off    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Department < ActiveRecord::Base
	attr_accessible :name, :max_off

	has_many :users

	validates :name, presence: true
	validates_uniqueness_of :name, case_sensitive: false, message: 'already exists'
	validates :max_off, presence: true

	def self.search(search)
		if search
			where("name ILIKE ?", "%#{search}%")
		else
			scoped
		end
	end

	def requests
		user_ids = self.users.map(&:id).join(', ')
		user_ids = "NULL" if user_ids.empty?
		requests = Request.where("user_id IN (#{user_ids}) AND approved = ? AND denied = ?", false, false).order('created_at ASC')
	end
end
