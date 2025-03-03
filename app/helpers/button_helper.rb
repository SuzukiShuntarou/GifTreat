# frozen_string_literal: true

module ButtonHelper
  def active_or_not(target_name)
    current_page_button?(target_name) ? 'active' : ''
  end

  def button_primary_or_not(target_name)
    current_page_button?(target_name) ? 'btn btn-primary' : 'btn btn-outline-primary'
  end

  private

  def current_page_button?(target_name)
    paths = request.url.split(/[=?&]/)
    active_button = paths.include?('completed') ? 'completed' : 'inprogress'
    active_button == target_name
  end
end
