class ApplicationController < ActionController::Base
	before_filter :set_user_time_zone

 	protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

 	include CalendarHelper
 	include DepartmentsHelper
 	include EventsHelper
 	include RequestsHelper
 	include SessionsHelper
 	include UsersHelper

 	private

    def not_found
      redirect_to root_path
    end

 		def set_user_time_zone
      #	Time.zone = "UTC"
		  Time.zone = 'Pacific Time (US & Canada)'
	  end
end