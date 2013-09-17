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

require 'test_helper'

class HalfDayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
