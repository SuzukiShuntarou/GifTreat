# frozen_string_literal: true

require 'test_helper'

class LikingTest < ActiveSupport::TestCase
  test 'should not be able to create likings exceeding maximum count' do
    current_user = users(:alice)
    goal = goals(:goal_with_max_count_likings_cheerings)
    liking = goal.likings.build(user: current_user)
    liking.save
    assert_predicate liking, :invalid?
  end
end
