module EventsHelper

 	def event_names
 		Event.all.map(&:name).uniq.sort
 	end

 	def user_event_names(user)
 		user.events.map(&:name).uniq.sort
 	end
end