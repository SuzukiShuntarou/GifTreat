# frozen_string_literal: true

class Goal < ApplicationRecord
  MAX_REWARD_RELATED_GOALS = 4
  MIN_PROGRESS = 0
  MAX_PROGRESS = 100
  belongs_to :user
  belongs_to :reward
  has_many :likings, dependent: :destroy
  has_many :cheerings, dependent: :destroy

  validates :description, presence: true, length: { maximum: 140 }
  validates :progress, presence: true, numericality: { greater_than_or_equal_to: MIN_PROGRESS, less_than_or_equal_to: MAX_PROGRESS, only_integer: true }
  validate :validate_reward_related_goals_limit, on: :create
  validate :validate_in_progress, on: :update

  def self.search_rewards_completed_or_in_progress(display, current_user)
    goals = Goal.includes(:reward).where(user: current_user)
    if display == 'completed'
      goals.where(rewards: { completion_date: ...Date.current }).order(rewards: { completion_date: :desc, id: :asc })
    else
      goals.where(rewards: { completion_date: Date.current.. }).order(rewards: { completion_date: :asc, id: :asc })
    end
  end

  def owned_by?(current_user)
    user == current_user
  end

  def achieved?
    progress == MAX_PROGRESS
  end

  private

  def validate_reward_related_goals_limit
    errors.add(:goal, 'は1つのご褒美に4つまでしか関連付けできません') if reward.goals.count >= MAX_REWARD_RELATED_GOALS
  end

  def validate_in_progress
    return if reward.in_progress?

    errors.add(:description, 'は終了後の変更はできません')
    errors.add(:progress, 'は終了後の変更はできません')
  end
end
