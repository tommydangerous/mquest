class HalfDay < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true
  validates_presence_of :name

  before_save :downcase_attributes

  private

    def downcase_attributes
      self.name = self.name.downcase
    end
    
end
