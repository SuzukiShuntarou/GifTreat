# frozen_string_literal: true

class LikingsController < ApplicationController
  def create
    @goal = Goal.find(params[:goal_id])
    @liking = @goal.likings.build(user: current_user)
    @liking.save!
  end
end
