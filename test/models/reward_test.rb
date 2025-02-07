# frozen_string_literal: true

require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  setup do
    @current_user = users(:alice)
    @other_user = users(:bob)
    @reward_in_progress = rewards(:alice_reward_in_progress)
    @reward_completed = rewards(:alice_reward_completed)
  end

  test 'should be in progress' do
    assert_predicate @reward_in_progress, :in_progress?
  end

  test 'should not be in progress' do
    assert_not @reward_completed.in_progress?
  end

  test 'should be created associated with User and Reward, RewardParticipant' do
    reward = Reward.create(
      completion_date: Date.current.to_s,
      location: '北海道',
      description: '旅行',
      invitation_token: SecureRandom.urlsafe_base64
    )
    assert_not RewardParticipant.find_by(user: @current_user, reward: reward).present?
    reward.create_reward_participants(@current_user)
    assert_predicate RewardParticipant.find_by(user: @current_user, reward: reward), :present?
  end

  test 'should be created associated with other_user and reward when invited, RewardParticipant' do
    assert_not RewardParticipant.find_by(user: @other_user, reward: @reward_in_progress).present?
    @reward_in_progress.create_reward_participants(@other_user)
    assert_predicate RewardParticipant.find_by(user: @other_user, reward: @reward_in_progress), :present?
  end

  test 'should have initial Goal created associated with other_user and reward when invited' do
    assert_not Goal.find_by(user: @other_user, reward: @reward_in_progress).present?
    @reward_in_progress.create_initial_goal_by_invited(@other_user)
    assert_predicate(Goal.find_by(user: @other_user, reward: @reward_in_progress), :present?)
  end
end
