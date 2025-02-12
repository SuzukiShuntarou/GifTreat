# frozen_string_literal: true

require 'application_system_test_case'

class GoalsTest < ApplicationSystemTestCase
  setup do
    @alice_goal_in_progress = goals(:alice_goal_in_progress)
    @alice_goal_completed = goals(:alice_goal_completed)

    @alice_reward_in_progress = rewards(:alice_reward_in_progress)
    @alice_reward_completed = rewards(:alice_reward_completed)

    visit new_user_session_path
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_link_or_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'should display goals list screen when nav-logo clicked' do
    click_link_or_button 'nav-logo'

    assert_selector 'a', text: '実施中'
    assert_selector 'a', text: '終了'
    assert_selector 'a', text: 'ご褒美を追加する'

    assert_text '期日'
    assert_text '目標'
    assert_text '進捗率'
  end

  test 'should display in-progress goals on list screen of in-progress goals' do
    click_link_or_button 'nav-logo'
    click_link_or_button '実施中'

    assert_text @alice_reward_in_progress.completion_date
    assert_text @alice_goal_in_progress.description
    assert_text @alice_goal_in_progress.progress
  end

  test 'should display completed goals on list screen of completed goals' do
    click_link_or_button 'nav-logo'
    click_link_or_button '終了'

    assert_text @alice_reward_completed.completion_date
    assert_text @alice_goal_completed.description
    assert_text @alice_goal_completed.progress
  end

  test 'should redirect to Reward screen related to the goal when the goal clicked' do
    click_link_or_button '実施中'
    click_link_or_button @alice_goal_in_progress.description
    assert_current_path "/rewards/#{@alice_reward_in_progress.id}"

    click_link_or_button 'nav-logo'

    click_link_or_button '終了'
    click_link_or_button @alice_goal_completed.description
    assert_current_path "/rewards/#{@alice_reward_completed.id}"
  end

  test 'should be able to redirect to new form from goals screen' do
    click_link_or_button 'ご褒美を追加する'
    assert_current_path new_reward_path
  end
end
