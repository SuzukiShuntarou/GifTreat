# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title without title' do
    assert_equal 'GifTreat', full_title('')
  end

  test 'full title with title' do
    assert_equal 'テストタイトル | GifTreat', full_title('テストタイトル')
  end
end
