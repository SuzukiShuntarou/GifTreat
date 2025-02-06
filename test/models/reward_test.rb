# frozen_string_literal: true

require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  setup do
    @current_user = users(:alice)
    @reward_in_progress = rewards(:alice_reward_in_progress)
    @reward_completed = rewards(:alice_reward_completed)
  end

  test 'should be in progress' do
    assert_predicate @reward_in_progress, :in_progress?
  end

  test 'should not be in progress' do
    assert_not @reward_completed.in_progress?
  end
end
