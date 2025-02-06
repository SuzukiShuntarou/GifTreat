# frozen_string_literal: true

class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :reward
  has_many :likings, dependent: :destroy
  has_many :cheerings, dependent: :destroy

  validates :description, presence: true
  validates :progress, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_integer: true }

  def self.search_rewards_completed_or_in_progress(display, current_user)
    goals = Goal.includes(:reward)
                .where(user: current_user)
                .order('rewards.completion_date ASC, rewards.id ASC')
    if display == 'completed'
      goals.where(rewards: { completion_date: ...Date.current }).reverse
    else
      goals.where(rewards: { completion_date: Date.current.. })
    end
  end

  def owned_by?(current_user)
    user == current_user
  end
end
