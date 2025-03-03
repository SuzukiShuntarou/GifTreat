# frozen_string_literal: true

require 'test_helper'

class RewardsHelperTest < ActionView::TestCase
  test 'should return true when count of reward_participants was maximum' do
    reward = rewards(:reward_with_alice_bob_charlie_david)
    assert max_reward_participants?(reward)
  end

  test 'should return false when count of reward_participants was not maximum' do
    reward = rewards(:alice_reward_in_progress)
    assert_not max_reward_participants?(reward)
  end
end
