# frozen_string_literal: true

require 'application_system_test_case'

class NavigationBarTest < ApplicationSystemTestCase
  setup do
    current_user = users(:alice)
    sign_in current_user
    visit goals_path
  end

  test 'should display link in offcanvas when clicked navigation bar button' do
    assert_no_selector 'a', text: 'トップページ'
    assert_selector 'a', { text: 'ご褒美を追加する', count: 1 }
    assert_no_selector 'a', text: '登録情報'
    assert_no_selector 'a', text: 'ログアウト'

    assert_selector 'button[aria-label="ナビゲーションバーの表示ボタン"]'
    find("[aria-label='ナビゲーションバーの表示ボタン']").click

    assert_selector 'a', text: 'トップページ'
    assert_selector 'a', { text: 'ご褒美を追加する', count: 2 }
    assert_selector 'a', text: '登録情報'
    assert_selector 'a', text: 'ログアウト'
  end

  test 'should display goals_path when clicked top-page' do
    find("[aria-label='ナビゲーションバーの表示ボタン']").click
    within('#offcanvasNavbar') { click_link_or_button 'トップページ' }
    assert_current_path goals_path
    assert_text '目標一覧'
  end

  test 'should display new_reward_path when clicked add-reward' do
    find("[aria-label='ナビゲーションバーの表示ボタン']").click
    within('#offcanvasNavbar') { click_link_or_button 'ご褒美を追加する' }
    assert_current_path new_reward_path
    assert_text '自分にご褒美をあげたい日までに達成したい目標を書いてください。どんな些細なことでも構いません！'
  end

  test 'should display edit_user_registration_path when clicked registration-information' do
    find("[aria-label='ナビゲーションバーの表示ボタン']").click
    within('#offcanvasNavbar') { click_link_or_button '登録情報' }
    assert_current_path edit_user_registration_path
    assert_text '登録情報変更'
  end

  test 'should display sign_in_path when clicked logout' do
    find("[aria-label='ナビゲーションバーの表示ボタン']").click
    within('#offcanvasNavbar') { click_link_or_button 'ログアウト' }
    assert_current_path new_user_session_path
    assert_text 'ログアウトしました。'
  end

  test 'should hide offcanvas when clicked close button' do
    find("[aria-label='ナビゲーションバーの表示ボタン']").click
    within('#offcanvasNavbar') { find("[aria-label='ナビゲーションバーの非表示ボタン']").click }

    assert_current_path goals_path
    assert_text '目標一覧'
    assert_no_selector 'a', text: 'トップページ'
    assert_selector 'a', { text: 'ご褒美を追加する', count: 1 }
    assert_no_selector 'a', text: '登録情報'
    assert_no_selector 'a', text: 'ログアウト'
  end
end
