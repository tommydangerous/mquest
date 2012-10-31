module DepartmentsHelper
	include Rails.application.routes.url_helpers

	def department_list
		Department.order(:name).collect { |d| [d.name, d.id] }
	end

	def department_req
		Department.order(:name).collect { |d| [d.name, requests_department_path(d)] }
	end
end