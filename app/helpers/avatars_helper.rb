# frozen_string_literal: true

module AvatarsHelper
  def avatar_path(avatar)
    if Rails.env.production?
      ENV.fetch('PUBLIC_URL', nil) + avatar.variant(:profile_icon).key
    else
      avatar.variant(:profile_icon)
    end
  end
end
