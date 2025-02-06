# frozen_string_literal: true

module ButtonHelper
  def current_page_button_or_not(target_name)
    current_page_button(target_name) ? 'active' : ''
  end

  def current_page_button_primary(target_name)
    current_page_button(target_name) ? 'btn btn-primary' : 'btn btn-outline-primary'
  end

  private

  def current_page_button(target_name)
    paths = request.url.split(/[=?&]/)
    active_button = paths.include?('completed') ? 'completed' : 'inprogress'
    active_button == target_name
  end
end
