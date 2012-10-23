class Department < ActiveRecord::Base
	attr_accessible :name, :max_off

	has_many :users

	validates :name, presence: true
	validates_uniqueness_of :name, case_sensitive: false, message: 'already exists'
	validates :max_off, presence: true
end