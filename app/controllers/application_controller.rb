class ApplicationController < ActionController::Base
	before_filter :set_user_time_zone

 	protect_from_forgery

 	include CalendarHelper
 	include RequestsHelper
 	include SessionsHelper
 	include UsersHelper

 	private

 		def set_user_time_zone
	  		Time.zone = "Pacific Time (US & Canada)"
	  	end
end