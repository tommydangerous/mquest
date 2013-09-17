# == Schema Information
#
# Table name: decisions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  request_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class DecisionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
