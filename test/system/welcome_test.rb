# frozen_string_literal: true

require 'application_system_test_case'

class WelcomesTest < ApplicationSystemTestCase
  setup do
    visit new_user_session_path
  end

  test 'should visit terms service page' do
    assert_no_text 'この利用規約（以下，「本規約」といいます。）は'

    assert_selector 'a', text: '利用規約'
    click_link_or_button '利用規約'

    assert_selector 'h2', text: '利用規約'
    assert_text 'この利用規約（以下，「本規約」といいます。）は'
  end

  test 'should visit privacy policy page' do
    assert_no_text '以下のとおりプライバシーポリシー（以下，「本ポリシー」といいます。）を'

    assert_selector 'a', text: 'プライバシーポリシー'
    click_link_or_button 'プライバシーポリシー'

    assert_selector 'h2', text: 'プライバシーポリシー'
    assert_text '以下のとおりプライバシーポリシー（以下，「本ポリシー」といいます。）を'
  end
end
