# frozen_string_literal: true

class Reward < ApplicationRecord
  MIN_PROGRESS = 0
  has_many :reward_participants, dependent: :destroy
  has_many :users, through: :reward_participants
  has_many :goals, dependent: :destroy

  accepts_nested_attributes_for :goals, allow_destroy: true

  validates :invitation_token, presence: true, uniqueness: true
  with_options presence: true do
    validates :description, length: { maximum: 40 }
    validates :location, length: { maximum: 40 }
    validates :completion_date
  end
  validate :validate_in_progress
  validate :validate_in_progress_for_updating, on: :update
  before_destroy { throw :abort unless in_progress? }

  def in_progress?
    completion_date&.after? Date.current.yesterday
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
    Reward.transaction do
      reward_participant = reward.reward_participants.build(user: current_user)
      initial_goal = reward.goals.build(
        user: current_user,
        description: "招待されました！#{current_user.name}さんの目標を登録しましょう！",
        progress: MIN_PROGRESS
      )

      reward_participant.save! && initial_goal.save!
    end
  end

  def valid_invitation_token?(token)
    invitation_token == token
  end

  private

  def validate_in_progress
    errors.add(:completion_date, 'は今日以降の日付を選択してください') unless in_progress?
  end

  def validate_in_progress_for_updating
    return if in_progress?

    errors.add(:location, 'は終了後の変更はできません')
    errors.add(:description, 'は終了後の変更はできません')
  end
end
