# frozen_string_literal: true

class RewardsController < ApplicationController
  def show; end

  def new
    @reward = Reward.new
    @reward.goals.build
  end

  def edit; end

  def create
    @reward = Reward.new(reward_and_goal_params)
    @reward.invitation_token = SecureRandom.urlsafe_base64
    @reward.goals.each { |goal| goal.user = current_user }

    ActiveRecord::Base.transaction do
      @reward.save!
      @reward.users << current_user
      redirect_to @reward, notice: 'ご褒美と目標の登録に成功！'
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end
  end

  private

  def reward_and_goal_params
    params.require(:reward).permit(:completion_date, :description, :location, goals_attributes: %i[description progress])
  end
end
