# frozen_string_literal: true

class Liking < ApplicationRecord
  belongs_to :user
  belongs_to :goal, counter_cache: :likings_count
end
