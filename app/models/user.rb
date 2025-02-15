# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ACCEPTED_CONTENT_TYPES = ['image/png', 'image/jpeg', 'image/gif'].freeze
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :reward_participants, dependent: :destroy
  has_many :rewards, through: :reward_participants
  has_many :goals, dependent: :destroy
  has_many :likings, dependent: :destroy
  has_many :cheerings, dependent: :destroy
  has_one_attached :avatar do |attachable|
    attachable.variant :profile_icon, resize_to_limit: [75, 75]
  end
  validates :name, presence: true, length: { maximum: 10 }
  validates :avatar, content_type: { in: ACCEPTED_CONTENT_TYPES, message: :content_type }
end
