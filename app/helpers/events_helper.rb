module EventsHelper

 	def event_names
 		purpose_ids = Event.all.map(&:purpose_id).uniq.join(', ')
 		if purpose_ids.empty?
 			purposes = []
 		else
 			purposes = Purpose.where("id IN (#{purpose_ids})").order(:name).map { |purpose| purpose.name }
 		end
 		purposes
 	end

 	def user_event_names(user)
 		purpose_ids = user.events.map(&:purpose_id).uniq.join(', ')
 		if purpose_ids.empty?
 			purposes = []
 		else
 			purposes = Purpose.where("id IN (#{purpose_ids})").order(:name).map { |purpose| purpose.name }
 		end
 		purposes
 	end
end