# frozen_string_literal: true

module AvatarsHelper
  def avatar_path(avatar)
    if Rails.env.production?
      ENV.fetch('PUBLIC_URL', nil) + avatar.key
    else
      avatar
    end
  end
end
