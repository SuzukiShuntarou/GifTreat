# frozen_string_literal: true

class InvitationsController < ApplicationController
  def index
    current_reward = current_user.reward_participants.find_by!(reward_id: params[:reward_id]).reward
    @invitation_url = reward_url(params[:reward_id], invitation_token: current_reward.invitation_token)
  end
end
