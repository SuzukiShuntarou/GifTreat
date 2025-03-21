# frozen_string_literal: true

require 'application_system_test_case'

class LikingsTest < ApplicationSystemTestCase
  setup do
    current_user = users(:alice)
    sign_in current_user
    visit goals_path
  end

  test 'should increase count when liking button clicked' do
    reward_in_progress = rewards(:alice_reward_in_progress)
    goal_in_progress = goals(:alice_goal_in_progress)

    visit reward_path(reward_in_progress)

    within("div#likings_#{dom_id(goal_in_progress)}") do
      current_likings_count = goal_in_progress.likings_count
      assert_text current_likings_count
      click_link_or_button 'いいねのマーク'
      assert_text (current_likings_count + 1).to_s
      click_link_or_button 'いいねのマーク'
      assert_text (current_likings_count + 2).to_s
    end
  end
end
