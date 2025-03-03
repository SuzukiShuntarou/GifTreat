# frozen_string_literal: true

require 'test_helper'

class CheeringsHelperTest < ActionView::TestCase
  test 'should update message when cheerings create' do
    reward = Reward.new(
      completion_date: Date.current, location: '北海道', description: '旅行',
      goals_attributes: [{ description: '早起きする', progress: 0 }]
    )
    Reward.bulk_create(reward, users(:alice))
    goal = reward.goals.first

    assert_equal 'まだ静かな時間が流れているね。応援で流れを変えてみては？', generate_cheerings_message(goal.cheerings)
    goal.cheerings.create(user: users(:alice))
    assert_equal 'Aliceが応援しているよ！', generate_cheerings_message(goal.cheerings)
    goal.cheerings.create(user: users(:bob))
    assert_equal 'AliceとBobが応援しているよ！', generate_cheerings_message(goal.cheerings)
  end
end
