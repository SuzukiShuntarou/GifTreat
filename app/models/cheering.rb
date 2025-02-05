# frozen_string_literal: true

class Cheering < ApplicationRecord
  belongs_to :user
  belongs_to :goal
end
