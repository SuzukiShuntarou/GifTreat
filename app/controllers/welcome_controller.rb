# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def terms_service; end

  def privacy_policy; end
end
