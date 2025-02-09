# frozen_string_literal: true

class Cheering < ApplicationRecord
  MAX_CHEERINGS_COUNT = 100
  belongs_to :user
  belongs_to :goal, counter_cache: :cheerings_count

  validate :validate_cheerings_count_limit, on: :create

  private

  def validate_cheerings_count_limit
    errors.add(:cheering, 'は1つの目標に対して最大100です') if goal.cheerings_count >= MAX_CHEERINGS_COUNT
  end
end
