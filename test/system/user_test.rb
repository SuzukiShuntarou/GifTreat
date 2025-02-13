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

  test 'should editable registration' do
    sign_in @current_user
    visit root_path
    click_link_or_button 'default-avatar'

    fill_in 'ユーザ名', with: 'new-alice'
    fill_in 'メールアドレス', with: 'new-alice@example.com'
    fill_in 'パスワード', with: 'newpassword'
    fill_in 'パスワード（確認用）', with: 'newpassword'
    fill_in '現在のパスワード', with: 'password'
    click_link_or_button '更新'

    assert_current_path edit_user_registration_path
    assert_text 'アカウント情報を変更しました。'
    assert_equal 'new-alice', find('input[name="user[name]"]').value
    assert_equal 'new-alice@example.com', find('input[name="user[email]"]').value
  end

  test 'should be able to delete own account from user edit page' do
    sign_in @current_user
    visit root_path
    click_link_or_button 'default-avatar'

    click_link_or_button 'アカウント削除'
    page.accept_alert

    assert_current_path new_user_session_path
    assert_text 'アカウントを削除しました。またのご利用をお待ちしております。'
  end
end
