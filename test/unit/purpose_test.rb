# == Schema Information
#
# Table name: purposes
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ignore_max_off :boolean          default(FALSE)
#

require 'test_helper'

class PurposeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
