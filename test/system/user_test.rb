# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @current_user = users(:alice)
  end

  test 'should show own user edit page' do
    sign_in @current_user
    visit root_path
    click_link_or_button 'default-avatar'

    assert_text '登録情報変更'
    assert_equal @current_user.name, find('input[name="user[name]"]').value
    assert_equal @current_user.email, find('input[name="user[email]"]').value
  end
end
