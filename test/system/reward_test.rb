# frozen_string_literal: true

require 'application_system_test_case'

class RewardsTest < ApplicationSystemTestCase
  setup do
    @reward = rewards(:alice_reward_in_progress)
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_link_or_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting rewards show in progress' do
    goal = goals(:alice_goal_in_progress)

    visit reward_path(@reward)

    within('#reward') do
      assert_text @reward.completion_date
      assert_text @reward.location
      assert_text @reward.description

      assert_selector 'a', text: '編集'
      assert_selector 'a', text: '削除'
      assert_selector 'button', text: '招待用URL！'
    end

    within("div##{dom_id(goal)}") do
      assert_text goal.user.name
      assert_text goal.description
      assert_text goal.progress

      assert_selector 'a', text: '編集'
    end

    within("div#likings_#{dom_id(goal)}") { assert_text goal.likings_count }
    within("div#cheerings_#{dom_id(goal)}") { assert_text goal.cheerings_count }
  end
end
