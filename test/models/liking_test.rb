# frozen_string_literal: true

require 'test_helper'

class LikingTest < ActiveSupport::TestCase
  test 'should not be able to create likings exceeding maximum count' do
    current_user = users(:alice)
    goal = goals(:goal_with_max_count_likings_cheerings)
    liking = goal.likings.build(user: current_user)
    liking.save
    assert_predicate liking, :invalid?
    assert_includes liking.errors[:liking], 'は1つの目標に対して最大100です'
  end
end
