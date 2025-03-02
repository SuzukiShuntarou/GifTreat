# frozen_string_literal: true

module RewardsHelper
  MAX_REWARD_PARTICIPANTS = 4

  def max_reward_participants?(reward)
    reward.reward_participants.count >= MAX_REWARD_PARTICIPANTS
  end
end
