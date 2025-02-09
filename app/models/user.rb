# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reward_participants, dependent: :destroy
  has_many :rewards, through: :reward_participants
  has_many :goals, dependent: :destroy
  has_many :likings, dependent: :destroy
  has_many :cheerings, dependent: :destroy
  has_one_attached :avatar do |attachable|
    attachable.variant :profile_icon, resize_to_limit: [100, 100]
  end
  validates :name, presence: true
end
