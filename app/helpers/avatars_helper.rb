# frozen_string_literal: true

module AvatarsHelper
  def avatar_url(avatar)
    if Rails.env.production?
      ENV.fetch('PUBLIC_URL', nil) + avatar.blob.key
    else
      avatar
    end
  end
end
