# frozen_string_literal: true

module AvatarsHelper
  def avatar_path(avatar)
    if Rails.env.production?
      key = avatar.variant(:profile_icon).key || avatar.key
      ENV.fetch('PUBLIC_URL', nil) + key
    else
      avatar
    end
  end
end
