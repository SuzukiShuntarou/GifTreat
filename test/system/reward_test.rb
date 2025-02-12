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

  test 'should show details of Reward and Goal, with edit and delete buttons, in progress' do
    goal_in_progress = goals(:alice_goal_in_progress)

    visit reward_path(@reward_in_progress)

    within('#reward') do
      assert_text @reward_in_progress.completion_date
      assert_text @reward_in_progress.location
      assert_text @reward_in_progress.description

      assert_selector 'a', text: '編集'
      assert_selector 'a', text: '削除'
      assert_selector 'button', text: '招待用URL：最大4人'
    end

    within("div##{dom_id(goal_in_progress)}") do
      assert_text goal_in_progress.user.name
      assert_text goal_in_progress.description
      assert_text goal_in_progress.progress

      assert_selector 'a', text: '編集'
    end

    within("div#likings_#{dom_id(goal_in_progress)}") { assert_text goal_in_progress.likings_count }
    within("div#cheerings_#{dom_id(goal_in_progress)}") { assert_text goal_in_progress.cheerings_count }
  end

  test 'should show details of Reward and Goal, without edit and delete buttons, on completed' do
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

  test 'should be able to create both Reward and Goal from common form' do
    visit goals_path
    click_link_or_button 'ご褒美を追加する'

    within("form[action='/rewards']") do
      fill_in 'reward[completion_date]', with: Date.current.tomorrow
      fill_in 'reward[location]', with: '叙々苑'
      fill_in 'reward[description]', with: '焼肉'
      fill_in 'reward[goals_attributes][0][description]', with: '毎日早寝早起きする'
      fill_in 'reward[goals_attributes][0][progress]', with: 20
      click_link_or_button 'ご褒美と目標を登録する'
    end

    assert_text 'ご褒美と目標の登録に成功！'

    reward = Reward.last
    goal = Goal.last
    assert_current_path "/rewards/#{reward.id}"

    within('#reward') do
      assert_text Date.current.tomorrow
      assert_text '叙々苑'
      assert_text '焼肉'
    end

    within("div##{dom_id(goal)}") do
      assert_text '毎日早寝早起きする'
      assert_text '20'
    end

    within("div#likings_#{dom_id(goal)}") { assert_text 0 }
    within("div#cheerings_#{dom_id(goal)}") { assert_text 0 }
  end
end
