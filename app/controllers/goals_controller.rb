# frozen_string_literal: true

class GoalsController < ApplicationController
  PAGER_NUMBER = 10
  before_action :set_goal, only: %i[edit update]

  def index
    @completed_or_in_progress = params[:rewards]
    @goals = Goal.search_rewards_completed_or_in_progress(@completed_or_in_progress, current_user).page(params[:page]).per(PAGER_NUMBER)
  end

  def edit; end

  def update
    if @goal.update(goal_params)
      flash.now.notice = '目標の更新に成功！'
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
