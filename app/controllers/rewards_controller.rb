# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :set_reward, only: %i[edit update destroy]

  def show
    reward_id = params[:id]
    groups = RewardParticipant.includes(reward: { goals: :user }).where(user: current_user)
    @reward = groups.find_by!(reward_id:).reward
    @goals = @reward.goals
  end

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

  def update
    if @reward.in_progress? && @reward.update(reward_params)
      flash.now[:updated_reward_notice] = 'ご褒美の編集に成功！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reward.destroy! if @reward.in_progress?
    redirect_to goals_path, notice: 'ご褒美の削除に成功！'
  end

  private

  def reward_and_goal_params
    params.require(:reward).permit(:completion_date, :description, :location, goals_attributes: %i[description progress])
  end

  def reward_params
    params.require(:reward).permit(:completion_date, :description, :location)
  end

  def set_reward
    @reward = current_user.reward_participants.find_by!(reward_id: params[:id]).reward
  end
end
