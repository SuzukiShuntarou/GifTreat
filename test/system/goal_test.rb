# frozen_string_literal: true

require 'application_system_test_case'

class GoalsTest < ApplicationSystemTestCase
  setup do
    @alice_goal_in_progress = goals(:alice_goal_in_progress)
    @alice_goal_completed = goals(:alice_goal_completed)

    @alice_reward_in_progress = rewards(:alice_reward_in_progress)
    @alice_reward_completed = rewards(:alice_reward_completed)

    current_user = users(:alice)
    sign_in current_user
    visit root_path
  end

  test 'should display goals list screen when nav-logo clicked' do
    click_link_or_button 'ヘッダーのGifTreatのロゴ'

    assert_selector 'a', text: '実施中'
    assert_selector 'a', text: '終了'
    assert_selector 'a', text: 'ご褒美を追加する'

    assert_text '期日'
    assert_text '目標'
    assert_text '進捗率'
  end

  test 'should display in-progress goals on list screen of in-progress goals' do
    click_link_or_button 'ヘッダーのGifTreatのロゴ'
    click_link_or_button '実施中'

    assert_text @alice_reward_in_progress.completion_date
    assert_text @alice_goal_in_progress.description
    assert_text @alice_goal_in_progress.progress
  end

  test 'should display completed goals on list screen of completed goals' do
    click_link_or_button 'ヘッダーのGifTreatのロゴ'
    click_link_or_button '終了'

    assert_text @alice_reward_completed.completion_date
    assert_text @alice_goal_completed.description
    assert_text @alice_goal_completed.progress
  end

  test 'should redirect to Reward screen related to the goal when the goal clicked' do
    click_link_or_button '実施中'
    click_link_or_button @alice_goal_in_progress.description
    assert_current_path reward_path(@alice_reward_in_progress.id)

    click_link_or_button 'ヘッダーのGifTreatのロゴ'

    click_link_or_button '終了'
    click_link_or_button @alice_goal_completed.description
    assert_current_path reward_path(@alice_reward_completed.id)
  end

  test 'should be able to redirect to new form from goals screen' do
    click_link_or_button 'ご褒美を追加する'
    assert_current_path new_reward_path
  end

  test 'should display message on goals screen when no rewards and goals registered' do
    find('.navbar-toggler').click
    click_link_or_button 'ログアウト'
    assert_text 'ログアウトしました。'

    user_without_rewards_and_goals = users(:user_without_rewards_goals)
    sign_in user_without_rewards_and_goals
    visit root_path

    click_link_or_button '実施中'
    assert_text 'ご褒美と目標が登録されていません。'

    click_link_or_button '終了'
    assert_text '終了したご褒美と目標がありません。'
  end
end
