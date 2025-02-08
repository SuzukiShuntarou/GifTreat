# frozen_string_literal: true

class Reward < ApplicationRecord
  has_many :reward_participants, dependent: :destroy
  has_many :users, through: :reward_participants
  has_many :goals, dependent: :destroy

  accepts_nested_attributes_for :goals, allow_destroy: true

  validates :invitation_token, presence: true, uniqueness: true
  with_options presence: true do
    validates :description
    validates :location
    validates :completion_date
  end

  def in_progress?
    completion_date.after? Date.current.yesterday
  end

  def self.bulk_create(reward, current_user)
    all_valid = true
    Reward.transaction do
      reward.invitation_token = SecureRandom.urlsafe_base64
      reward.goals.first.user = current_user
      reward_participant = reward.reward_participants.build(user: current_user)

      all_valid &= reward.save && reward_participant.save
      raise ActiveRecord::Rollback unless all_valid
    end
    all_valid
  end

  def self.bulk_create_by_invited(reward, current_user)
    all_valid = true
    Reward.transaction do
      reward_participant = reward.reward_participants.build(user: current_user)
      initial_goal = reward.goals.build(
        user: current_user,
        description: "招待されました！#{current_user.name}さんの目標を登録しましょう！",
        progress: 0
      )

      all_valid &= reward_participant.save && initial_goal.save
      raise ActiveRecord::Rollback unless all_valid
    end
    all_valid
  end
end
