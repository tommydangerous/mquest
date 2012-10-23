class Request < ActiveRecord::Base
 	attr_accessible :request_start,
 					:request_end,
 					:total_days,
 					:total_hours,
 					:purpose,
 					:comments,
 					:scheduled,
 					:called_in,
 					:absence_paid,
 					:remarks

 	belongs_to :user

 	has_many :events, dependent: :destroy
 	
 	validates :request_start, presence: true
 	validates :request_end, presence: true
 	validates :total_hours, presence: true
 	validates :user_id, presence: true

 	def self.search(search)
 		if search
 			search = search.to_s
 			if Rails.env.production?
 				where("purpose ILIKE ? OR comments ILIKE ?", "%#{search}%", "%#{search}%")
 			else
 				where("purpose LIKE ? OR comments LIKE ?", "%#{search}%", "%#{search}%")
 			end
 		else
 			scoped
 		end
 	end

 	def conflicts
 		Event.where('event_date >= ? AND event_date <= ?', self.request_start, self.request_end)
 	end
end