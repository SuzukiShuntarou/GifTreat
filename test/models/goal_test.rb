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

  test 'should be owner' do
    assert @goal_in_progress.owned_by?(@current_user)
  end

  test 'should not be owner' do
    assert_not @goal_in_progress.owned_by?(@other_user)
  end

  test 'should not be able to add more goals than the maximum count for reward' do
    reward_related_max_count_goals = rewards(:reward_with_alice_bob_charlie_david)
    another_user = users(:eve)
    assert_not RewardParticipant.find_by(user: another_user, reward: reward_related_max_count_goals).present?

    assert_raises(ActiveRecord::RecordInvalid) do
      Reward.bulk_create_by_invited(reward_related_max_count_goals, another_user)
    end
    assert_not RewardParticipant.find_by(user: another_user, reward: reward_related_max_count_goals).present?
    assert_predicate reward_related_max_count_goals, :invalid?
  end

  test 'should not be editable after completion date' do
    @goal_completed.update(
      description: '早寝早起きする',
      progress: '100'
    )
    assert_predicate @goal_completed, :invalid?
    assert_includes @goal_completed.errors[:description], 'は終了後の変更はできません'
    assert_includes @goal_completed.errors[:progress], 'は終了後の変更はできません'
  end

  test 'should be achieved' do
    goal = Goal.new(description: '達成済', progress: 100)
    assert_predicate goal, :achieved?
  end

  test 'should not be achieved' do
    goal = Goal.new(description: '未達成', progress: 99)
    assert_not goal.achieved?
  end
end
