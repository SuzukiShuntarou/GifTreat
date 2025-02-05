# frozen_string_literal: true

class RewardParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :user_id, uniqueness: { scope: :reward_id }
end
