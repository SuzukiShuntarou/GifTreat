# frozen_string_literal: true

module AvatarsHelper
  def avatar_url(avatar)
    if Rails.env.production?
      ENV.fetch('PUBLIC_URL', nil) + avatar.variant.key
    else
      avatar
    end
  end
end
