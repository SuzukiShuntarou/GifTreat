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
    completiondate.after? Date.current.yesterday
  end
end
