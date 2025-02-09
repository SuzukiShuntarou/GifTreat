# frozen_string_literal: true

class Liking < ApplicationRecord
  MAX_LIKINGS_COUNT = 100
  belongs_to :user
  belongs_to :goal, counter_cache: :likings_count

  validate :validate_likings_count_limit, on: :create

  private

  def validate_likings_count_limit
    errors.add(:liking, 'は1つの目標に対して最大100です') if goal.likings_count >= MAX_LIKINGS_COUNT
  end
end
