# frozen_string_literal: true

module CheeringsHelper
  def generate_cheerings_message(cheerings)
    user_names = cheerings.joins(:user).pluck('users.name').uniq

    if user_names.empty?
      'まだ静かな時間が流れているね。応援で流れを変えてみては？'
    else
      "#{user_names.join('と')}が応援しているよ！"
    end
  end
end
