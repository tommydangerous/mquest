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
 			search = search.to_s
 			if Rails.env.production?
 				where("name ILIKE ? OR event_date ILIKE ?", "%#{search}%", "%#{search}%")
 			else
 				where("name LIKE ? OR event_date LIKE ?", "%#{search}%", "%#{search}%")
 			end
 		else
 			scoped
 		end
 	end
end