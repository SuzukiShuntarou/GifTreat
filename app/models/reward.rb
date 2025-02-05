# frozen_string_literal: true

class Reward < ApplicationRecord
  has_many :users, through: :rewardparticipants
  has_many :rewardparticipants, dependent: :destroy
  has_many :goals, dependent: :destroy

  validates :invitation_token, presence: true, uniqueness: true
  with_options presence: true do
    validates :description
    validates :location
    validates :completion_date
  end
end
