# frozen_string_literal: true

class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :reward
  has_many :likings, dependent: :destroy
  has_many :cheerings, dependent: :destroy

  validates :description, presence: true
  validates :progress, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_integer: true }
end
