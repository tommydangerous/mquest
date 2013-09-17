# == Schema Information
#
# Table name: secrets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Secret < ActiveRecord::Base
 	attr_accessible :name, :code

 	validates :name, presence: true, uniqueness: true
 	validates :code, presence: true
end
