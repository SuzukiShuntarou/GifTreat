# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ACCEPTED_CONTENT_TYPES = ['image/png', 'image/jpeg', 'image/gif'].freeze
  MAX_AVATAR_SIZE = 1
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reward_participants, dependent: :destroy
  has_many :rewards, through: :reward_participants
  has_many :goals, dependent: :destroy
  has_many :likings, dependent: :destroy
  has_many :cheerings, dependent: :destroy
  has_one_attached :avatar
  validates :name, presence: true, length: { maximum: 10 }
  validates :avatar, content_type: { in: ACCEPTED_CONTENT_TYPES, message: :content_type },
                     size: { less_than: MAX_AVATAR_SIZE.megabytes, message: "ファイルサイズは#{MAX_AVATAR_SIZE}MB以下にしてください" }
end
