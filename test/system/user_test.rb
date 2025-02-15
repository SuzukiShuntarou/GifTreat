# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @current_user = users(:alice)
  end

  test 'should login' do
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_link_or_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'should logout' do
    sign_in @current_user
    visit root_path
    click_link_or_button 'ログアウト'
    assert_text 'ログアウトしました。'
  end

  test 'should show own user edit page' do
    sign_in @current_user
    visit root_path
    click_link_or_button 'デフォルトのユーザアイコン'

    assert_text '登録情報変更'
    assert_equal @current_user.name, find('input[name="user[name]"]').value
    assert_equal @current_user.email, find('input[name="user[email]"]').value
  end

  test 'should editable registration' do
    sign_in @current_user
    visit root_path
    click_link_or_button 'デフォルトのユーザアイコン'

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
    click_link_or_button 'デフォルトのユーザアイコン'

    click_link_or_button 'アカウント削除'
    page.accept_alert

    assert_current_path new_user_session_path
    assert_text 'アカウントを削除しました。またのご利用をお待ちしております。'
  end

  test 'should create new user' do
    visit new_user_session_path
    assert_selector 'a', text: '無料でアカウント登録'
    click_link_or_button '無料でアカウント登録'

    assert_selector 'h2', text: 'アカウント登録'
    fill_in 'ユーザ名', with: '東京 太郎'
    fill_in 'メールアドレス', with: 'tokyotaro@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'
    click_link_or_button 'アカウント登録'

    assert_text 'アカウント登録が完了しました。'
    assert_text 'まだ自分へのご褒美と目標が１つも登録されていません。'
    click_link_or_button 'デフォルトのユーザアイコン'

    assert_text '登録情報変更'
    assert_equal '東京 太郎', find('input[name="user[name]"]').value
    assert_equal 'tokyotaro@example.com', find('input[name="user[email]"]').value
  end
end
