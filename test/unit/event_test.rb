# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  event_date     :datetime
#  date_requested :datetime
#  user_id        :integer
#  approved_by    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  request_id     :integer
#  purpose_id     :integer
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
