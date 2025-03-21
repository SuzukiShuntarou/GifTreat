# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_update_path_for(_resource)
    edit_user_registration_path
  end
end
