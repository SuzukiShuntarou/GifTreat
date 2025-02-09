# frozen_string_literal: true

class GoalsController < ApplicationController
  before_action :set_goal, only: %i[edit update]

  def index
    @selected_display = params[:display]
    @goals = Goal.search_rewards_completed_or_in_progress(@selected_display, current_user).page(params[:page]).per(10)
  end

  def edit; end

  def update
    if @goal.update(goal_params)
      flash.now[:updated_goal_notice] = '目標の編集に成功！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:description, :progress)
  end

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end
end
