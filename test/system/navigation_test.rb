# frozen_string_literal: true

require 'application_system_test_case'

class NavigationBarTest < ApplicationSystemTestCase
  setup do
    current_user = users(:alice)
    sign_in current_user
    visit root_path
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
end
