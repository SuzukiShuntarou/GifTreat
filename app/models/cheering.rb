# frozen_string_literal: true

class Cheering < ApplicationRecord
  belongs_to :user
  belongs_to :goal, counter_cache: :cheerings_count
end
