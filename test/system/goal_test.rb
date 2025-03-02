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
    assert_selector 'a', text: @alice_goal_in_progress.description
    assert_text @alice_goal_in_progress.progress
  end

  test 'should display completed goals on list screen of completed goals' do
    click_link_or_button 'ヘッダーのGifTreatのロゴ'
    click_link_or_button '終了'

    assert_text @alice_reward_completed.completion_date
    assert_selector 'a', text: @alice_goal_completed.description
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

  test 'should be editable goal in progress' do
    visit reward_path(@alice_reward_in_progress)

    within("div##{dom_id(@alice_goal_in_progress)}") do
      assert_selector 'a', text: '編集'
      click_link_or_button '編集'
    end

    within('.modal-title') { assert_text '目標の編集' }

    within('.modal-body') do
      fill_in '目標', with: 'ランニングする'
      fill_in '進捗率', with: '99'
      click_link_or_button '更新'
    end

    assert_text '目標の更新に成功！'

    within("div##{dom_id(@alice_goal_in_progress)}") do
      assert_text 'ランニングする'
      assert_equal '99', find('input[name="goal[progress]"]').value
    end
  end

  test 'should be able to update progress with slider' do
    visit reward_path(@alice_reward_in_progress)

    within("div##{dom_id(@alice_goal_in_progress)}") do
      assert_no_selector 'input[type="submit"][value="更新"]'
      assert_no_selector 'a', text: '取消'

      slider = find('input[type="range"]')
      slider.send_keys(:end)
      assert_equal '100', find('input[name="goal[progress]"]').value

      assert_selector 'input[type="submit"][value="更新"]'
      assert_selector 'a', text: '取消'

      click_link_or_button '更新'
    end

    assert_text '目標の更新に成功！'

    within("div##{dom_id(@alice_goal_in_progress)}") do
      assert_no_selector 'input[type="submit"][value="更新"]'
      assert_no_selector 'a', text: '取消'
      assert_equal '100', find('input[name="goal[progress]"]').value
    end
  end

  test 'should be able to cancel progress update with slider' do
    visit reward_path(@alice_reward_in_progress)
    progress_before_slider_operation = @alice_goal_in_progress.progress

    within("div##{dom_id(@alice_goal_in_progress)}") do
      assert_no_selector 'input[type="submit"][value="更新"]'
      assert_no_selector 'a', text: '取消'

      slider = find('input[type="range"]')
      slider.send_keys(:home)
      assert_equal '0', find('input[name="goal[progress]"]').value

      assert_selector 'input[type="submit"][value="更新"]'
      assert_selector 'a', text: '取消'

      click_link_or_button '取消'
    end

    assert_current_path reward_path(@alice_reward_in_progress)

    within("div##{dom_id(@alice_goal_in_progress)}") do
      assert_no_selector 'input[type="submit"][value="更新"]'
      assert_no_selector 'a', text: '取消'
      assert_equal progress_before_slider_operation.to_s, find('input[name="goal[progress]"]').value
    end
  end

  test 'should display grade-very-good-stamp when goal was achieved' do
    visit reward_path(@alice_reward_completed)

    within("div##{dom_id(@alice_goal_completed)}") do
      assert_text '100'
      assert_selector 'img[alt="たいへんよくできました！スタンプ"]'
    end
  end

  test 'should display grade-good-stamp when goal was unachieved' do
    unachieved_reward = rewards(:alice_reward_completed_unachieved)
    unachieved_goal = goals(:alice_goal_completed_unachieved)
    visit reward_path(unachieved_reward)

    within("div##{dom_id(unachieved_goal)}") do
      assert_text '99'
      assert_selector 'img[alt="がんばりました！スタンプ"]'
    end
  end
end
