# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = Goal.search_rewards_completed_or_in_progress(params[:display], current_user)
  end

  def edit; end
end
