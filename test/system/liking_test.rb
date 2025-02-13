# frozen_string_literal: true

require 'application_system_test_case'

class LikingsTest < ApplicationSystemTestCase
  setup do
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_link_or_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'should increase count when liking button clicked' do
    reward_in_progress = rewards(:alice_reward_in_progress)
    goal_in_progress = goals(:alice_goal_in_progress)

    visit reward_path(reward_in_progress)

    within("div#likings_#{dom_id(goal_in_progress)}") do
      current_likings_count = goal_in_progress.likings_count
      assert_text current_likings_count
      click_link_or_button
      assert_text (current_likings_count + 1).to_s
      click_link_or_button
      assert_text (current_likings_count + 2).to_s
    end
  end
end
