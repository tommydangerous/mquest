# == Schema Information
#
# Table name: half_days
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  max_off    :integer
#

class HalfDay < ActiveRecord::Base
  attr_accessible :max_off, :name

  validates :max_off, presence: true
  validates :name,    presence: true
  validates_presence_of :name

  before_save :downcase_attributes

  private

    def downcase_attributes
      self.name = self.name.downcase
    end
    
end
