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

  test 'should not login' do
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'incorrectpassword'
    click_link_or_button 'ログイン'
    assert_text 'メールアドレスまたはパスワードが違います。'
  end

  test 'should logout' do
    sign_in @current_user
    visit root_path
    find('.navbar-toggler').click
    click_link_or_button 'ログアウト'
    assert_text 'ログアウトしました。'
  end

  test 'should show own user edit page' do
    sign_in @current_user
    visit root_path
    find('.navbar-toggler').click
    click_link_or_button '登録情報'

    assert_text '登録情報変更'
    assert_equal @current_user.name, find('input[name="user[name]"]').value
    assert_equal @current_user.email, find('input[name="user[email]"]').value
  end

  test 'should editable registration' do
    sign_in @current_user
    visit root_path
    find('.navbar-toggler').click
    click_link_or_button '登録情報'

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
    find('.navbar-toggler').click
    click_link_or_button '登録情報'

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
    assert_text 'ご褒美と目標が登録されていません。'
    find('.navbar-toggler').click
    click_link_or_button '登録情報'

    assert_text '登録情報変更'
    assert_equal '東京 太郎', find('input[name="user[name]"]').value
    assert_equal 'tokyotaro@example.com', find('input[name="user[email]"]').value
  end

  test 'should be able to reset password from change password view' do
    visit new_user_session_path
    assert_selector 'a', text: 'パスワードをお忘れですか？'
    click_link_or_button 'パスワードをお忘れですか？'

    assert_selector 'h2', text: 'パスワード再設定'
    fill_in 'メールアドレス', with: 'alice@example.com'
    click_link_or_button '送信'

    assert_text 'パスワードの再設定について、メールでご連絡いたします。'
    assert_current_path new_user_session_path

    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries.last
    assert_equal @current_user.email, mail.to[0]
    assert_equal '【GifTreat】パスワードの再設定について', mail.subject

    user = User.find_by(email: @current_user.email)
    token = user.send(:set_reset_password_token)
    visit edit_user_password_path(reset_password_token: token)
    assert_selector 'h2', text: 'パスワード再設定'
    fill_in 'パスワード', with: 'newpassword'
    fill_in 'パスワード（確認用）', with: 'newpassword'
    click_link_or_button 'パスワード再設定'

    assert_text 'パスワードが変更されました。'
    find('.navbar-toggler').click
    click_link_or_button 'ログアウト'
    assert_text 'ログアウトしました。'

    visit new_user_session_path
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_link_or_button 'ログイン'
    assert_text 'メールアドレスまたはパスワードが違います。'

    visit new_user_session_path
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'newpassword'
    click_link_or_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'should upload image as user avatar' do
    sign_in @current_user
    visit edit_user_registration_path
    attach_file 'user[avatar]', 'test/fixtures/files/avatar-sample.png'
    fill_in '現在のパスワード', with: 'password'
    click_link_or_button '更新'

    assert_text 'アカウント情報を変更しました。'
    img = find('img[alt="ユーザのアイコン"]')
    assert_match(/avatar-sample\.png$/, img.native['src'])
  end
end
