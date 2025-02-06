# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @selected_display = params[:display]
    @goals = Goal.search_rewards_completed_or_in_progress(@selected_display, current_user)
  end

  def edit; end
end
