# frozen_string_literal: true

require 'test_helper'

class ButtonHelperTest < ActionDispatch::IntegrationTest
  include ButtonHelper
  test 'should be active only compatible button when accessed in-progress or completed goals-path' do
    get goals_path(rewards: 'inprogress')
    assert_equal 'active', active_or_not('inprogress')
    assert_equal '', active_or_not('completed')

    get goals_path(rewards: 'completed')
    assert_equal '', active_or_not('inprogress')
    assert_equal 'active', active_or_not('completed')
  end
end
