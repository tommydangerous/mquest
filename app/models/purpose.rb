# == Schema Information
#
# Table name: purposes
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ignore_max_off :boolean          default(FALSE)
#

class Purpose < ActiveRecord::Base
	attr_accessible :ignore_max_off, :name

	has_many :requests
	has_many :events

	validates :name, presence: true
	validates_uniqueness_of :name

	default_scope { order 'name ASC' }

	before_save :downcase_attributes

	def self.search(search)
		if search
			where("name ILIKE ?", "%#{search}%")
		else
			scoped
		end
	end

	private

		def downcase_attributes
			self.name = name.try :downcase
		end

end
