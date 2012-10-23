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
 			if Rails.env.production?
 				where("name ILIKE ?", "%#{search}%")
 			else
 				where("name LIKE ?", "%#{search}%")
 			end
 		else
 			scoped
 		end
 	end
end