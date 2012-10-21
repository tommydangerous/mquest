class Secret < ActiveRecord::Base
 	attr_accessible :name, :code

 	validates :name, presence: true, uniqueness: true
 	validates :code, presence: true
end