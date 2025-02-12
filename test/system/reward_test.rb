# frozen_string_literal: true

require 'application_system_test_case'

class RewardsTest < ApplicationSystemTestCase
  setup do
    @reward_in_progress = rewards(:alice_reward_in_progress)
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_link_or_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting rewards show in progress' do
    goal = goals(:alice_goal_in_progress)

    visit reward_path(@reward_in_progress)

    within('#reward') do
      assert_text @reward_in_progress.completion_date
      assert_text @reward_in_progress.location
      assert_text @reward_in_progress.description

      assert_selector 'a', text: '編集'
      assert_selector 'a', text: '削除'
      assert_selector 'button', text: '招待用URL：最大4人'
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

  test 'should show details of Reward and Goal, without edit and delete buttons, on Reward completed' do
    reward_completed = rewards(:alice_reward_completed)
    goal_completed = goals(:alice_goal_completed)

    visit reward_path(reward_completed)

    within('#reward') do
      assert_text reward_completed.completion_date
      assert_text reward_completed.location
      assert_text reward_completed.description

      assert_no_selector 'a', text: '編集'
      assert_no_selector 'a', text: '削除'
      assert_no_selector 'button', text: '招待用URL：最大4人'
    end

    within("div##{dom_id(goal_completed)}") do
      assert_text goal_completed.user.name
      assert_text goal_completed.description
      assert_text goal_completed.progress

      assert_no_selector 'a', text: '編集'
    end
  end
end
