# frozen_string_literal: true

require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  setup do
    @current_user = users(:alice)
    @other_user = users(:bob)
    @goal_in_progress = goals(:alice_goal_in_progress)
    @goal_completed = goals(:alice_goal_completed)
  end

  test 'should only search in progress goals' do
    goals = Goal.search_rewards_completed_or_in_progress('inprogress', @current_user)
    assert_includes goals, @goal_in_progress
    assert_not_includes goals, @goal_completed
  end

  test 'should only search completed goals' do
    goals = Goal.search_rewards_completed_or_in_progress('completed', @current_user)
    assert_not_includes goals, @goal_in_progress
    assert_includes goals, @goal_completed
  end

  test 'should not search goals from other user' do
    goals_in_progress = Goal.search_rewards_completed_or_in_progress('inprogress', @other_user)
    assert_not_includes goals_in_progress, @goal_in_progress
    assert_not_includes goals_in_progress, @goal_completed

    goals_completed = Goal.search_rewards_completed_or_in_progress('completed', @other_user)
    assert_not_includes goals_completed, @goal_in_progress
    assert_not_includes goals_completed, @goal_completed
  end
end
