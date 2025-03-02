# frozen_string_literal: true

require 'application_system_test_case'

class RewardsTest < ApplicationSystemTestCase
  setup do
    @reward_in_progress = rewards(:alice_reward_in_progress)
    @goal_in_progress = goals(:alice_goal_in_progress)

    current_user = users(:alice)
    sign_in current_user
    visit root_path
  end

  test 'should show details of Reward and Goal, with edit and delete and invite buttons, in progress' do
    visit reward_path(@reward_in_progress)

    within('#reward') do
      assert_text @reward_in_progress.completion_date
      assert_text @reward_in_progress.location
      assert_text @reward_in_progress.description

      assert_selector 'a', text: '編集'
      assert_selector 'a', text: '招待'
    end

    within("div##{dom_id(@goal_in_progress)}") do
      assert_text @goal_in_progress.user.name
      assert_text @goal_in_progress.description
      assert_equal @goal_in_progress.progress.to_s, find('input[name="goal[progress]"]').value

      assert_selector 'a', text: '編集'
    end

    within("div#likings_#{dom_id(@goal_in_progress)}") { assert_text @goal_in_progress.likings_count }
    within("div#cheerings_#{dom_id(@goal_in_progress)}") { assert_text @goal_in_progress.cheerings_count }
    assert_selector 'a', text: '削除'
  end

  test 'should show details of Reward and Goal, without edit and delete and invite buttons, on completed' do
    reward_completed = rewards(:alice_reward_completed)
    goal_completed = goals(:alice_goal_completed)

    visit reward_path(reward_completed)

    within('#reward') do
      assert_text reward_completed.completion_date
      assert_text reward_completed.location
      assert_text reward_completed.description

      assert_no_selector 'a', text: '編集'
      assert_no_selector 'a', text: '招待'
    end

    within("div##{dom_id(goal_completed)}") do
      assert_text goal_completed.user.name
      assert_text goal_completed.description
      assert_text goal_completed.progress

      assert_no_selector 'a', text: '編集'
      assert_no_selector 'input[type="range"]'
    end
    assert_no_selector 'a', text: '削除'
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

    assert_text 'ご褒美の追加に成功！'

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
      assert_equal '20', find('input[name="goal[progress]"]').value
    end

    within("div#likings_#{dom_id(goal)}") { assert_text 0 }
    within("div#cheerings_#{dom_id(goal)}") { assert_text 0 }
  end

  test 'should be editable reward in progress' do
    visit reward_path(@reward_in_progress)

    within('#reward') do
      assert_selector 'a', text: '編集'
      click_link_or_button '編集'
    end

    within('.modal-title') { assert_text 'ご褒美の編集' }

    within('.modal-body') do
      fill_in '場所', with: '北海道'
      fill_in 'ご褒美', with: '旅行'
      click_link_or_button '更新'
    end

    assert_text 'ご褒美の更新に成功！'

    within('#reward') do
      assert_text '北海道'
      assert_text '旅行'
    end
  end

  test 'should delete reward and goal in progress' do
    visit reward_path(@reward_in_progress)

    assert_selector 'a', text: '削除'
    click_link_or_button '削除'
    page.accept_alert

    assert_current_path goals_path
    assert_text 'ご褒美の削除に成功！'
    assert_no_text @goal_in_progress.description
  end

  test 'should add goal for user who access the invitation URL for the reward' do
    visit reward_path(@reward_in_progress)

    within('#reward') do
      assert_selector 'a', text: '招待'
      click_link_or_button '招待'
    end

    within('.modal-title') { assert_text 'ご褒美へ友人・家族を招待' }

    within('.modal-body') do
      assert_text '招待したい人に以下のURLを共有してください。'
      assert_equal reward_url(@reward_in_progress.id, invitation_token: @reward_in_progress.invitation_token), find('input[name="invite_url"]').value
      click_link_or_button '招待用URLをコピー'
      assert_selector 'button', text: 'コピーしました！'
    end

    cdp_permission = {
      origin: page.server_url,
      permission: { name: 'clipboard-read' },
      setting: 'granted'
    }
    page.driver.browser.execute_cdp('Browser.setPermission', **cdp_permission)
    invited_url = page.evaluate_async_script('navigator.clipboard.readText().then(arguments[0])')

    other_user = users(:bob)
    sign_in other_user
    visit(invited_url)

    assert_text 'ご褒美に招待されました！'
    within('#reward') do
      assert_text @reward_in_progress.completion_date
      assert_text @reward_in_progress.location
      assert_text @reward_in_progress.description
    end

    initial_goal_by_invited = Goal.last

    within("div##{dom_id(initial_goal_by_invited)}") do
      assert_text 'Bob'
      assert_text '招待されました！Bobさんの目標を登録しましょう！'
      assert_equal '0', find('input[name="goal[progress]"]').value
      assert_selector 'a', text: '編集'
    end

    within("div#likings_#{dom_id(initial_goal_by_invited)}") { assert_text 0 }
    within("div#cheerings_#{dom_id(initial_goal_by_invited)}") { assert_text 0 }
  end

  test 'should be displayed error message when user who has already been invited accesses the invitation URL' do
    invited_reward = rewards(:reward_with_alice_bob)
    visit reward_path(invited_reward)

    within('#reward') do
      assert_selector 'a', text: '招待'
      click_link_or_button '招待'
    end

    within('.modal-body') do
      click_link_or_button '招待用URLをコピー'
      assert_selector 'button', text: 'コピーしました！'
    end

    cdp_permission = {
      origin: page.server_url,
      permission: { name: 'clipboard-read' },
      setting: 'granted'
    }
    page.driver.browser.execute_cdp('Browser.setPermission', **cdp_permission)
    invited_url = page.evaluate_async_script('navigator.clipboard.readText().then(arguments[0])')

    user_already_invited = users(:bob)
    sign_in user_already_invited
    visit(invited_url)

    assert_text '招待済のURLです。'
  end

  test 'should be displayed error message when invitation URL is incorrect' do
    invited_reward = @reward_in_progress
    visit reward_path(invited_reward)

    within('#reward') do
      assert_selector 'a', text: '招待'
      click_link_or_button '招待'
    end

    within('.modal-body') do
      click_link_or_button '招待用URLをコピー'
      assert_selector 'button', text: 'コピーしました！'
    end

    cdp_permission = {
      origin: page.server_url,
      permission: { name: 'clipboard-read' },
      setting: 'granted'
    }
    page.driver.browser.execute_cdp('Browser.setPermission', **cdp_permission)
    invited_url = page.evaluate_async_script('navigator.clipboard.readText().then(arguments[0])')
    incorrect_invited_url = "#{invited_url}incorrect_url"

    other_user = users(:bob)
    sign_in other_user
    visit(incorrect_invited_url)

    assert_text '無効な招待URLです。'
    assert_current_path goals_path
  end

  test 'should display default avatar in detail view of reward' do
    visit reward_path(@reward_in_progress)
    img = find('img[alt="デフォルトのユーザアイコン"]')
    assert_match(/default-avatar-[a-z0-9]+\.png$/, img.native['src'])
  end

  test 'should display upload avatar in detail view of reward' do
    visit edit_user_registration_path
    attach_file 'user[avatar]', 'test/fixtures/files/avatar-sample.png'
    fill_in '現在のパスワード', with: 'password'
    click_link_or_button '更新'

    visit reward_path(@reward_in_progress)
    img = find('img[alt="ユーザのアイコン"]')
    assert_match(/avatar-sample\.png$/, img.native['src'])
  end
end
