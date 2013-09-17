# == Schema Information
#
# Table name: requests
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  request_start :datetime
#  request_end   :datetime
#  total_days    :integer
#  total_hours   :integer
#  comments      :text
#  scheduled     :boolean
#  called_in     :boolean
#  absence_paid  :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  approved      :boolean          default(FALSE)
#  denied        :boolean          default(FALSE)
#  remarks       :text
#  manual        :boolean          default(FALSE)
#  approved_by   :integer
#  denied_by     :integer
#  manual_by     :integer
#  purpose_id    :integer
#  half_day      :boolean          default(FALSE)
#

require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
