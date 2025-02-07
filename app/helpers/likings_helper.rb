# frozen_string_literal: true

module LikingsHelper
  def generate_likings_message(likings)
    user_names = likings.joins(:user).pluck('users.name').uniq

    if user_names.empty?
      '頑張る人にひと押し、いいねボタンでさりげなく褒めてみて！'
    else
      "#{user_names.join('と')}が褒めてくれたよ！"
    end
  end
end
