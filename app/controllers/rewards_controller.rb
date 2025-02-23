# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :set_reward, only: %i[edit update destroy invite]

  def show
    reward_id = params[:id]
    invitation_token = params[:invitation_token]
    if invitation_token
      @reward = Reward.find(reward_id)
      return redirect_to goals_path, alert: '無効な招待URLです。' unless @reward.valid_invitation_token?(invitation_token)

      invite_to_reward(@reward, current_user)
    else
      set_reward
    end
    @goals = @reward.goals.includes(user: :avatar_attachment).order(:id)
  end

  def new
    @reward = Reward.new
    @reward.goals.build
  end

  def edit; end

  def create
    @reward = Reward.new(reward_and_goal_params)
    if Reward.bulk_create(@reward, current_user)
      redirect_to @reward, notice: 'ご褒美の追加に成功！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @reward.update(reward_params)
      flash.now.notice = 'ご褒美の更新に成功！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reward.destroy!
    redirect_to goals_path, notice: 'ご褒美の削除に成功！'
  end

  def invite; end

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

  def invite_to_reward(reward, current_user)
    return redirect_to reward, alert: '招待済のURLです。' if reward.users.include?(current_user)

    redirect_to reward, notice: 'ご褒美に招待されました！' if Reward.bulk_create_by_invited(reward, current_user)
  end
end
