# frozen_string_literal: true

require 'test_helper'

class CheeringTest < ActiveSupport::TestCase
  test 'should not be able to create cheerings exceeding maximum count' do
    current_user = users(:alice)
    goal = goals(:goal_with_max_count_likings_cheerings)
    cheering = goal.cheerings.build(user: current_user)
    cheering.save
    assert_predicate cheering, :invalid?
  end
end
