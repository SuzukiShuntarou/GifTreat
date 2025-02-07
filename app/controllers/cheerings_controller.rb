# frozen_string_literal: true

class CheeringsController < ApplicationController
  def create
    @goal = Goal.find(params[:goal_id])
    @cheering = @goal.cheerings.build(user: current_user)
    @cheering.save!
  end
end
