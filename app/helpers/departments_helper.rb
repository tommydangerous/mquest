module DepartmentsHelper

	def department_list
		Department.order(:name).collect { |d| [d.name, d.id] }
	end
end