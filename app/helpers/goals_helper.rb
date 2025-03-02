# frozen_string_literal: true

module GoalsHelper
  def image_stamp(goal)
    if goal.achieved?
      image_tag('grade-very-good.png', class: 'position-absolute bottom-0 end-0 h-25', alt: 'たいへんよくできました！スタンプ')
    else
      image_tag('grade-good.png', class: 'position-absolute bottom-0 end-0 h-25', alt: 'がんばりました！スタンプ')
    end
  end
end
