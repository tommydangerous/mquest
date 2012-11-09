class PagesController < ApplicationController
	before_filter :authenticate, only: :test
	before_filter :admin_user, only: :test
	before_filter :master_user, only: :test

	def not_found
		redirect_to root_path
	end

	def test
		@title = 'Test'
	end
end