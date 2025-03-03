# frozen_string_literal: true

require 'test_helper'

class LikingsHelperTest < ActionView::TestCase
  test 'should update message when likings create' do
    reward = Reward.new(
      completion_date: Date.current, location: '北海道', description: '旅行',
      goals_attributes: [{ description: '早起きする', progress: 0 }]
    )
    Reward.bulk_create(reward, users(:alice))
    goal = reward.goals.first

    assert_equal '頑張る人にひと押し、いいねボタンでさりげなく褒めてみて！', generate_likings_message(goal.likings)
    goal.likings.create(user: users(:alice))
    assert_equal 'Aliceが褒めてくれたよ！', generate_likings_message(goal.likings)
    goal.likings.create(user: users(:bob))
    assert_equal 'AliceとBobが褒めてくれたよ！', generate_likings_message(goal.likings)
  end
end
