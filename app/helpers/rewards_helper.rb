# frozen_string_literal: true

module RewardsHelper
  MAX_REWARD_RELATED_GOALS = 4

  def invited?(reward)
    reward.in_progress? && reward.goals.count < MAX_REWARD_RELATED_GOALS
  end
end
