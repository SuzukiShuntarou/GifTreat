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
    reward = Reward.new(
      completion_date: Date.current,
      location: '北海道',
      description: '旅行',
      goals_attributes: [
        {
          description: '早起きする',
          progress: 0
        }
      ]
    )
    assert_not RewardParticipant.find_by(user: @current_user, reward: reward).present?
    Reward.bulk_create(reward, @current_user)
    assert_predicate RewardParticipant.find_by(user: @current_user, reward: reward), :present?
  end

  test 'should be created associated with other_user and reward when invited, RewardParticipant' do
    assert_not RewardParticipant.find_by(user: @other_user, reward: @reward_in_progress).present?
    Reward.bulk_create_by_invited(@reward_in_progress, @other_user)
    assert_predicate RewardParticipant.find_by(user: @other_user, reward: @reward_in_progress), :present?
  end

  test 'should have initial Goal created associated with other_user and reward when invited' do
    assert_not Goal.find_by(user: @other_user, reward: @reward_in_progress).present?
    Reward.bulk_create_by_invited(@reward_in_progress, @other_user)
    assert_predicate(Goal.find_by(user: @other_user, reward: @reward_in_progress), :present?)
  end

  test 'should not be able to create after completion date' do
    reward = Reward.new(
      completion_date: Date.current.yesterday,
      location: '北海道',
      description: '旅行',
      goals_attributes: [
        {
          description: '早起きする',
          progress: 0
        }
      ]
    )
    Reward.bulk_create(reward, @current_user)
    assert_predicate reward, :invalid?
    assert reward.errors[:completion_date], 'は今日以降の日付を選択してください'
  end

  test 'should not be editable after completion date' do
    @reward_completed.update(
      location: '北海道',
      description: '旅行'
    )
    assert_predicate @reward_completed, :invalid?
    assert @reward_completed.errors[:completion_date], 'は今日以降の日付を選択してください'
  end

  test 'should be valid invitation_token' do
    correct_invitation_token = @reward_in_progress.invitation_token
    assert @reward_in_progress.valid_invitation_token?(correct_invitation_token)
  end

  test 'should be invalid invitation_token' do
    assert_not @reward_in_progress.valid_invitation_token?('incorrect_invitation_token')
  end
end
